# frozen_string_literal: true

require 'rails_helper'
require 'pry'

RSpec.describe 'Api::V1::Tweets' do
  describe '/api/v1/tweets' do
    # 全てのテストで事前に作成したユーザーデータを使用する。confirmed_atに日付を入れることでユーザーを有効にする
    # createはFactoryBot.createの略
    let(:user_a) { create(:user, name: 'ユーザーA', email: 'a@sample.com', password: 'password', confirmed_at: Time.zone.today) }

    it '投稿を削除する' do
      auth_tokens = sign_in(user_a)
      # createはFactoryBot.createの略
      tweet = create(:tweet, content: 'Aのタスク', user: user_a)

      # 投稿データを削除して投稿データの総数が1個減っているか確認する
      expect { delete "/api/v1/tweets/#{tweet.id}", headers: auth_tokens }.to change(Tweet, :count).by(-1)

      # リクエスト成功を表す200が返却された確認する
      expect(response).to have_http_status(:ok)
    end

    it '新しい投稿を作成する' do
      auth_tokens = sign_in(user_a)

      valid_params = { content: 'テスト投稿' }

      # 新しく投稿して投稿データの総数が1個増えているか確認する
      expect { post '/api/v1/tweets', params: { tweet: valid_params }, headers: auth_tokens }.to change(Tweet, :count).by(+1)

      # リクエスト成功を表す200が返却された確認する
      expect(response).to have_http_status(:ok)
    end

    it '投稿を全件取得' do
      auth_tokens = sign_in(user_a)
      # createはFactoryBot.createの略
      create(:tweet, content: 'Aのタスク', user: user_a)
      create(:tweet, content: 'Bのタスク', user: user_a)
      create(:tweet, content: 'Cのタスク', user: user_a)

      get '/api/v1/tweets', headers: auth_tokens

      # status, message, countのデータは不要なので指定して投稿データのみを取得する
      json = response.parsed_body['data']['tweets']

      # リクエスト成功を表す200が返却された確認する
      expect(response).to have_http_status(:ok)

      # 作成された投稿データの数が正しく取得できたかどうかを確認する
      expect(json.length).to eq(3)
    end

    it '特定の投稿を取得する' do
      auth_tokens = sign_in(user_a)
      # createはFactoryBot.createの略
      tweet = create(:tweet, content: 'Aのタスク', user: user_a)

      get "/api/v1/tweets/#{tweet.id}", headers: auth_tokens

      json = response.parsed_body

      # リクエスト成功を表す200が返却された確認する
      expect(response).to have_http_status(:ok)

      # 作成された投稿データとURLにアクセスして取得したデータが同一かどうか
      expect(json['data']['tweet']['content']).to eq(tweet['content'])
    end
  end
end
