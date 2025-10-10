# frozen_string_literal: true

class Group < ApplicationRecord
  has_many :entries, dependent: :destroy
  has_many :users, through: :entries
  has_many :messages, dependent: :destroy

  validate :group_user_limit

  def group_user_limit
    return unless entries.size >= 2

    errors.add(:group, 'このチャットグループには既に２人のユーザーが参加しています。')
  end

  # ユーザーデータを取得する時に論理削除されたユーザーを含まない
  scope :from_active_users, -> { joins(:user).merge(User.kept) }

  # このモデルでは論理削除を実行しない。１つのグループには２人のユーザーが入るので、片方のユーザーが論理削除された時に
  # グループを論理削除するともう片方側のユーザー側でグループが見つからなくてエラーが発生する。
end
