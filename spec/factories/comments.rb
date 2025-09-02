# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    content { '試しにコメント' }
    user
    tweet
  end
end
