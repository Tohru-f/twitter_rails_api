# frozen_string_literal: true

require 'rails_helper'
require 'pry'

RSpec.describe 'Api::V1::Bookmarks' do
  describe 'api/v1/bookmarks' do
    let(:user_a) { create(:user, name: 'ユーザーA', email: 'a@sample.com', password: 'password', confirmed_at: Time.zone.today) }
    let(:user_b) { create(:user, name: 'ユーザーB', email: 'b@sample.com', password: 'password', confirmed_at: Time.zone.today) }
    let(:user_c) { create(:user, name: 'ユーザーC', email: 'c@sample.com', password: 'password', confirmed_at: Time.zone.today) }

    it 'ブックマークを作成する' do
      auth_tokens = sign_in(user_a)

      # createはFactoryBot.createの略
      tweet = create(:tweet, content: 'Bのタスク', user: user_b)

      # ユーザーAからユーザーBの投稿をブックマークした時にブックマークの総数が増えることを検証する
      expect { post '/api/v1/bookmarks', params: { tweet_id: tweet.id }, headers: auth_tokens }.to change(Bookmark, :count).by(+1)

      expect(response).to have_http_status(:success)
    end

    it '二重ブックマークはできない' do
      auth_tokens = sign_in(user_a)

      # createはFactoryBot.createの略
      tweet = create(:tweet, content: 'Bのタスク', user: user_b)

      # 投稿に対して新しくブックマーク
      post '/api/v1/bookmarks', params: { tweet_id: tweet.id }, headers: auth_tokens
      expect(response).to have_http_status(:success)

      # 同じ投稿に対して再度ブックマークを試みると複合ユニーク違反であるエラーが発生することを検証する
      expect { post '/api/v1/bookmarks', params: { tweet_id: tweet.id }, headers: auth_tokens }.to raise_error(ActiveRecord::RecordNotUnique)
    end

    it 'ブックマークを取得' do
      auth_tokens = sign_in(user_a)

      # createはFactoryBot.createの略
      tweet_b = create(:tweet, content: 'Bのタスク', user: user_b)
      tweet_c = create(:tweet, content: 'Cのタスク', user: user_c)

      # 投稿に対して新しくブックマーク
      post '/api/v1/bookmarks', params: { tweet_id: tweet_b.id }, headers: auth_tokens
      post '/api/v1/bookmarks', params: { tweet_id: tweet_c.id }, headers: auth_tokens

      # ブックマークの一覧を取得する
      get '/api/v1/bookmarks', headers: auth_tokens

      # 取得したブックマークを保管
      json = response.parsed_body['data']['bookmarks']

      # 取得したブックマークん数が期待した数であることを検証する
      expect(json.length).to eq(2)

      expect(response).to have_http_status(:success)
    end
  end
end
