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
end
