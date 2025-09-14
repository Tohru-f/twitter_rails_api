# frozen_string_literal: true

require 'rails_helper'
require 'pry'

RSpec.describe 'Api::V1::LoginUsers' do
  describe 'api/v1/login_users' do
    let(:user_a) { create(:user, name: 'ユーザーA', email: 'a@sample.com', password: 'password', confirmed_at: Time.zone.today) }

    it 'ログインユーザーの情報を取得する' do
      auth_tokens = sign_in(user_a)

      # ログインユーザーの情報を取得する
      get '/api/v1/login_users', headers: auth_tokens

      json = response.parsed_body

      # 生成してログインした後にサーバーから取得したユーザー情報(名前)とFactoryBotで生成したユーザーの情報(名前)が等しいか検証する
      expect(json['data']['user']['name']).to eq(user_a['name'])

      expect(response).to have_http_status(:success)
    end

    # it 'ログインユーザーの情報を更新する' do
    #   pending "add some examples (or delete) #{__FILE__}"

    # auth_tokens = sign_in(user_a)

    # valid_params = { name: '山田太郎' }

    # put '/api/v1/login_users', params: {login_user: valid_params}, headers: auth_tokens

    # json = response.parsed_body

    # expect{json['data']['user']['name']}.to eq(user_a['name'])

    # expect(response).to have_http_status(:success)
    # end
  end
end
