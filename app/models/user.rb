# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :omniauthable, omniauth_providers: [:google_oauth2]
  has_many :tweets, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :retweets, dependent: :destroy
  has_one_attached :icon
  has_one_attached :header
  validates :phone_number, presence: true
  validates :email, presence: true, uniqueness: true
  validates :birthday, presence: true
  # validates :name, presence: true, length: {in: 1..50}, default: "" プロフィール機能実装まではコメントアウト
  # validates :profile, length: {in: 1..160} プロフィール機能実装まではコメントアウト

  # 引数authから取得したproviderとuidを持つユーザーを探し、存在すればそのユーザーデータを使用し、
  # 存在しなければ、google側から取得したデータを元にユーザーを新しく生成する
  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.email = auth.info.email
      user.password = 'password'
      user.name = auth.info.name
      user.phone_number = '090-1234-5678'
      user.birthday = '20250101'
    end
  end

  # オブジェクトをJSON形式に変換する際の出力内容をカスタマイズする。通常の属性(idやname)に加えてimage_urlsメソッドの返り値も含める
  # as_jsonはrender json: で自動的に呼び出される
  def as_json(options = {})
    super(options.merge(methods: %i[header_urls icon_urls]))
  end

  # ユーザーに紐づくヘッダー画像からファイルのアクセスURLを生成し、配列で返す。
  def header_urls
    return unless header.attached?

    url_for(header)
  end

  # ユーザーに紐づくアイコン画像からファイルのアクセスURLを生成し、配列で返す。
  def icon_urls
    return unless icon.attached?

    url_for(icon)
  end

  include DeviseTokenAuth::Concerns::User
  include Rails.application.routes.url_helpers
end
