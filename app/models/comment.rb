# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :tweet
  has_many :notifications, dependent: :destroy
  validates :content, presence: true, length: { in: 1..116 }
end
