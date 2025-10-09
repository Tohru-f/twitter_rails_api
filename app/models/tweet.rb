# frozen_string_literal: true

class Tweet < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :user
  validates :content, presence: true, length: { in: 1..140 }
  has_many_attached :images
  has_many :comments, dependent: :destroy
  has_many :retweets, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  has_many :notifications, dependent: :destroy

  def check_notification(current_api_v1_user, action)
    temp = current_api_v1_user.active_notifications.where(visited_id: user_id, tweet_id: id, action:)
    temp.present?
  end

  # ユーザーデータを取得する時に論理削除されたユーザーを含まない
  scope :from_active_users, -> { joins(:user).merge(User.kept) }

  # discard(gem)を使用できるように設定
  include Discard::Model
  # デフォルトの取得内容を変更。これによりdiscardで論理削除されたデータは含まない。
  default_scope -> { kept }

  def create_notification!(current_api_v1_user, action, user_id:, comment_id: nil)
    # イイね、若しくはリツイートされている場合は処理を終了する
    return if check_notification(current_api_v1_user, action) && action == %w[favorite retweet]

    notification = current_api_v1_user.active_notifications.new(
      tweet_id: id,
      visited_id: user_id,
      comment_id:,
      action:,
      # 自分の投稿に対するイイね、リツイート、コメントの場合は通知済みとする
      checked: current_api_v1_user.id == user_id
    )
    notification.save if notification.valid?
  end

  def create_notification_comment!(current_api_v1_user, comment_id)
    # 自分以外にコメントしている人を全て取得して、全員に通知を送る
    temp_ids = Comment.select(:user_id).where(tweet_id: id).where.not(user_id: current_api_v1_user.id).distinct
    temp_ids.each do |temp_id|
      create_notification!(current_api_v1_user, 'comment', user_id: temp_id['user_id'], comment_id:)
    end
    # まだ誰もコメントしていない場合は投稿者に送る
    create_notification!(current_api_v1_user, 'comment', user_id:, comment_id:)
  end

  # オブジェクトをJSON形式に変換する際の出力内容をカスタマイズする。通常の属性(idやname)に加えてimage_urlsメソッドの返り値も含める
  def as_json(options = {})
    super(options.merge(methods: :image_urls))
  end

  # モデルに紐づく複数の画像から各画像ファイルのアクセスURLを生成し、配列で返す。
  def image_urls
    images.map { |image| url_for(image) }
  end
end
