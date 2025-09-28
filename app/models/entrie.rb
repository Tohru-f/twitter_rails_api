# frozen_string_literal: true

class Entrie < ApplicationRecord
  belongs_to :user
  belongs_to :group

  # ユーザーとグループに一意性も持たせるため、複合ユニークの設定を入れる。
  # アプリケーションレベルで一意性を確保。バリデーションエラーはデータベースエラーと異なり、ユーザーフレンドリー。
  validates :user_id, uniqueness: { scope: :group_id }
end
