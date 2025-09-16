# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'テストユーザー' }
    email { 'test@sample.com' }
    phone_number { '09012345678' }
    birthday { '19000101' }
    password { 'password' }

    # after(:build) do |user|
    #   user.header.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'default_header.png')), filename: 'default_header.png', content_type: 'image/png')
    #   user.icon.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'default_icon.png')), filename: 'default_icon.png', content_type: 'image/png')
    # end
  end
end
