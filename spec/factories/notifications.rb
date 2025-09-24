# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    visitor { association :visitor, factory: :user }
    visited { association :visited, factory: :user }
    tweet
    comment
    action
    checked { false }
  end
end
