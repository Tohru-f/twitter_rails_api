# frozen_string_literal: true

require 'rails_helper'
require 'pry'

RSpec.describe 'Api::V1::Retweets' do
  describe 'api/v1/tweets/:id/retweets' do
    let(:user_a) { create(:user, name: 'ユーザーA', email: 'a@sample.com', password: 'password', confirmed_at: Time.zone.today) }

    it 'リツイートを新規作成する' do
      auth_tokens = sign_in(user_a)

      tweet = create(:tweet, content: 'タスクA', user: user_a)

      # 新しいリツイートを作成して、データ数が増えたかどうか検証する
      expect { post "/api/v1/tweets/#{tweet.id}/retweets", headers: auth_tokens }.to change(Retweet, :count).by(+1)

      # リクエスト成功を表す200が返却された確認する
      expect(response).to have_http_status(:success)
    end

    it 'リツイートを削除する' do
      auth_tokens = sign_in(user_a)

      tweet = create(:tweet, content: 'タスクA', user: user_a)

      create(:retweet, user: user_a, tweet:)

      expect { delete "/api/v1/tweets/#{tweet.id}/retweets", headers: auth_tokens }.to change(Retweet, :count).by(-1)

      expect(response).to have_http_status(:success)
    end
  end
end
