# frozen_string_literal: true

require 'rails_helper'
require 'pry'

RSpec.describe 'Api::V1::Comments' do
  describe 'api/v1/comments' do
    let(:user_a) { create(:user, name: 'ユーザーA', email: 'a@sample.com', password: 'password', confirmed_at: Time.zone.today) }

    it 'コメントを作成する' do
      auth_tokens = sign_in(user_a)
      # createはFactoryBot.createの略
      tweet = create(:tweet, content: 'Aのタスク', user: user_a)

      valid_params = { content: 'お試しコメント' }

      # 新しくコメントしてデータの総数が1個増えているか確認する
      expect do
        post '/api/v1/comments', params: { comment: valid_params, tweet_id: tweet.id }, headers: auth_tokens
      end.to change(Comment, :count).by(+1)

      # リクエスト成功を表す200が返却された確認する
      expect(response).to have_http_status(:ok)
    end
  end
end
