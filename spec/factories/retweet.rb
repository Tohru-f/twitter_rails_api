# frozen_string_literal: true

FactoryBot.define do
  factory :retweet do
    user
    tweet
  end
end
