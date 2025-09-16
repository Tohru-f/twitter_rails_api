# frozen_string_literal: true

require 'rails_helper'
require 'pry'

RSpec.describe 'Api::V1::Users' do
  describe 'api/v1/users/:id' do
    let(:user_a) { create(:user, name: 'ユーザーA', email: 'a@sample.com', password: 'password', confirmed_at: Time.zone.today) }

    it '投稿からユーザー情報を取得する' do
      auth_tokens = sign_in(user_a)

      create(:tweet, content: 'タスクA', user: user_a)

      # ユーザー情報を元にツイートとそれに紐づくユーザー情報を取得する
      get "/api/v1/users/#{user_a.id}", headers: auth_tokens

      json = response.parsed_body

      # 生成したツイートに紐づくユーザーと生成したユーザーの情報(id)が同じか？
      expect(json['data']['tweets'][0]['user']['id']).to eq(user_a['id'])

      expect(response).to have_http_status(:success)
    end
  end
end
