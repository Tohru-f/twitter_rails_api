# frozen_string_literal: true

class Notification < ApplicationRecord
  # デフォルトの並び順を作成日時の降順(新しいものから取得)
  default_scope -> { order(created_at: :desc) }
  # optional: trueでカラム内のnilを許容する
  belongs_to :visitor, class_name: 'User'
  belongs_to :visited, class_name: 'User'
  belongs_to :tweet, optional: true
  belongs_to :comment, optional: true
end
