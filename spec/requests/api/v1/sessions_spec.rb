# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Sessions' do
  describe 'api/v1/sessions' do
    let(:user_a) { create(:user, name: 'ユーザーA', email: 'a@sample.com', password: 'password', confirmed_at: Time.zone.today) }

    it 'サインアウトする' do
      auth_tokens = sign_in(user_a)

      # サインアウトする
      delete '/api/v1/auth/sign_out', headers: auth_tokens

      json = response.parsed_body

      # 取得したメッセージが期待したものであることを検証する
      expect(json['message']).to eq('have logged out successfully')

      expect(response).to have_http_status(:success)
    end

    it 'ユーザーが退会(論理削除)した後でもサインアウトできる' do
      auth_tokens = sign_in(user_a)

      # 退会(論理削除)する
      delete '/api/v1/users', headers: auth_tokens
      # サインアウトする
      delete '/api/v1/auth/sign_out', headers: auth_tokens

      json = response.parsed_body

      # サインアウト時の返り値の中に期待したメッセージがあることを検証する
      # userモデルでdiscarded_atがnilであることを認証の条件としているが、
      # sessions_controllerでdestroyアクションを上書きして論理削除されたユーザーも含んだ状態で対象ユーザーを検索する実装にしている
      expect(json['message']).to eq('have logged out successfully')

      expect(response).to have_http_status(:success)
    end
  end
end
