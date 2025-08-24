# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'テストユーザー' }
    email { 'test@sample.com' }
    phone_number { '09012345678' }
    birthday { '19000101' }
    password { 'password' }
  end
end
