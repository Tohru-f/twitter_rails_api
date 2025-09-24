# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Registrations' do
  describe 'api/v1/auth' do
    it 'ユーザーを登録する' do
      # ユーザー登録詳細情報
      valid_params = { phone_number: '090-1234-5678', email: 'sample@yahoo.co.jp', birthday: '20190707', password: 'password', password_confirmation: 'password', confirm_success_url: 'http://localhost:5173' }

      # 新しくユーザーを登録して、ユーザー数が1個増えるかを検証する
      expect { post '/api/v1/auth', params: { registration: valid_params } }.to change(User, :count).by(+1)

      expect(response).to have_http_status(:ok)
    end

    it 'ユーザー登録に失敗する' do
      # ユーザー登録詳細情報(パスワードが不足している)
      valid_params = { phone_number: '090-1234-5678', email: 'sample@yahoo.co.jp', birthday: '20190707', password: '', password_confirmation: '', confirm_success_url: 'http://localhost:5173' }

      # 新しくユーザー登録を試みるが、パスワードを入力していないのでユーザー数は増えないことを検証する
      expect { post '/api/v1/auth', params: { registration: valid_params } }.not_to change(User, :count)
    end
  end
end
