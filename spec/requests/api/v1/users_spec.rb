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

    it 'ユーザーが退会する(論理削除)' do
      auth_tokens = sign_in(user_a)

      # 退会してユーザーを論理削除する
      delete '/api/v1/users', headers: auth_tokens

      json = response.parsed_body

      # 退会した時のメッセージが期待したものであることを検証する
      expect(json['message']).to eq('have soft-deleted user successfully')

      expect(response).to have_http_status(:success)
    end

    it 'ユーザーが退会(論理削除)した後はログインできない' do
      auth_tokens = sign_in(user_a)

      # 退会(論理削除)する
      delete '/api/v1/users', headers: auth_tokens
      # サインアウトする
      delete '/api/v1/auth/sign_out', headers: auth_tokens

      # 再度同じユーザーでログインを試みる
      sign_in(user_a)
      # 論理削除されたユーザーではログインできないので、401の認証エラーが発生することを検証する
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
