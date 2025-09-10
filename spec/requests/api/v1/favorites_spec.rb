# frozen_string_literal: true

require 'rails_helper'
require 'pry'

RSpec.describe 'Api::V1::Favorites' do
  describe 'api/v1/tweets/:id/favorites' do
    let(:user_a) { create(:user, name: 'ユーザーA', email: 'a@sample.com', password: 'password', confirmed_at: Time.zone.today) }

    it 'イイねを新規作成する' do
      auth_tokens = sign_in(user_a)

      tweet = create(:tweet, content: 'タスクA', user: user_a)

      # 新しくイイねを作成した結果、イイねの総数が1個増えたかどうか検証する
      expect { post "/api/v1/tweets/#{tweet.id}/favorites", headers: auth_tokens }.to change(Favorite, :count).by(+1)

      # リクエスト成功を表す200が返却された確認する
      expect(response).to have_http_status(:success)
    end

    it 'イイねを削除する' do
      auth_tokens = sign_in(user_a)

      tweet = create(:tweet, content: 'タスクA', user: user_a)

      create(:favorite, user: user_a, tweet:)

      # イイねを削除できるかどうかイイねの総数が減ったかどうかを確認して検証する
      expect { delete "/api/v1/tweets/#{tweet.id}/favorites", headers: auth_tokens }.to change(Favorite, :count).by(-1)

      # リクエスト成功を表す200が返却された確認する
      expect(response).to have_http_status(:success)
    end
  end
end
