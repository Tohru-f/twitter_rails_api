# frozen_string_literal: true

class Entrie < ApplicationRecord
  belongs_to :user
  belongs_to :group

  # ユーザーとグループに一意性も持たせるため、複合ユニークの設定を入れる。
  # アプリケーションレベルで一意性を確保。バリデーションエラーはデータベースエラーと異なり、ユーザーフレンドリー。
  validates :user_id, uniqueness: { scope: :group_id }

  # ユーザーデータを取得する時に論理削除されたユーザーを含まない
  scope :from_active_users, -> { joins(:user).merge(User.kept) }

  # discard(gem)を使用できるように設定
  include Discard::Model
  # デフォルトの取得内容を変更。これによりdiscardで論理削除されたデータは含まない。
  default_scope -> { kept }
end
