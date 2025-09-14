# frozen_string_literal: true

FactoryBot.define do
  factory :relation do
    user
    follower { association :follower, factory: :user }
  end
end
