# frozen_string_literal: true

require 'rails_helper'
require 'pry'

RSpec.describe 'Api::V1::Notifications' do
  describe 'api/v1/notifications' do
    let(:user_a) { create(:user, name: 'ユーザーA', email: 'a@sample.com', password: 'password', confirmed_at: Time.zone.today) }
    let(:user_b) { create(:user, name: 'ユーザーB', email: 'b@sample.com', password: 'password', confirmed_at: Time.zone.today) }

    it '通知一覧を取得する' do
      auth_tokens = sign_in(user_b)

      tweet = create(:tweet, content: 'タスクA', user: user_a)

      # ユーザーBでユーザーAの投稿にイイねする
      post "/api/v1/tweets/#{tweet.id}/favorites", headers: auth_tokens

      # ユーザーBでユーザーAをフォローする
      post "/api/v1/users/#{user_a.id}/follow", headers: auth_tokens

      # ユーザーBからユーザーAに切り替える
      sign_out(auth_tokens)
      auth_tokens = sign_in(user_a)

      # 通知情報を取得する
      get '/api/v1/notifications', headers: auth_tokens

      json = response.parsed_body['data']['notifications']

      # ユーザーBで実行したイイねとフォローの通知２件をユーザーA側で取得できているか確認
      expect(json.length).to eq(2)

      expect(response).to have_http_status(:success)
    end
  end
end
