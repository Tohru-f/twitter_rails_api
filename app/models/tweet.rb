# frozen_string_literal: true

class Tweet < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :user
  validates :content, presence: true, length: { in: 1..140 }
  has_many_attached :images
  has_many :comments, dependent: :destroy
  has_many :retweets, dependent: :destroy
  has_many :favorites, dependent: :destroy

  # オブジェクトをJSON形式に変換する際の出力内容をカスタマイズする。通常の属性(idやname)に加えてimage_urlsメソッドの返り値も含める
  def as_json(options = {})
    super(options.merge(methods: :image_urls))
  end

  # モデルに紐づく複数の画像から各画像ファイルのアクセスURLを生成し、配列で返す。
  def image_urls
    images.map { |image| url_for(image) }
  end
end
