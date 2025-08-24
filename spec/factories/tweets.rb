# frozen_string_literal: true

FactoryBot.define do
  factory :tweet do
    content { 'テスト投稿' }
    user
  end
end
