# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :tweet
  validates :content, presence: true, length: { in: 1..116 }
end
