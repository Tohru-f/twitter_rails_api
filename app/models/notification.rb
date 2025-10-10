# frozen_string_literal: true

class Notification < ApplicationRecord
  # デフォルトの並び順を作成日時の降順(新しいものから取得)
  default_scope -> { order(created_at: :desc) }
  # optional: trueでカラム内のnilを許容する
  belongs_to :visitor, class_name: 'User'
  belongs_to :visited, class_name: 'User'
  belongs_to :tweet, optional: true
  belongs_to :comment, optional: true

  # ユーザーデータを取得する時に論理削除されたユーザーを含まない
  scope :from_active_users, -> { joins(:user).merge(User.kept) }

  # discard(gem)を使用できるように設定
  include Discard::Model
  # デフォルトの取得内容を変更。これによりdiscardで論理削除されたデータは含まない。
  default_scope -> { kept }
end
