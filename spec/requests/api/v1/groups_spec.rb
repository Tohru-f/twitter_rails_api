# frozen_string_literal: true

require 'rails_helper'
require 'pry'

RSpec.describe 'Api::V1::Groups' do
  describe 'api/v1/groups' do
    let(:user_a) { create(:user, name: 'ユーザーA', email: 'a@sample.com', password: 'password', confirmed_at: Time.zone.today) }
    let(:user_b) { create(:user, name: 'ユーザーB', email: 'b@sample.com', password: 'password', confirmed_at: Time.zone.today) }

    it 'グループを作成する' do
      auth_tokens = sign_in(user_a)

      # ユーザーAとユーザーBの間でグループを作成し、グループ数が1件増えたことを検証する
      expect { post '/api/v1/groups', params: { user_id: user_b.id }, headers: auth_tokens }.to change(Group, :count).by(+1)

      expect(response).to have_http_status(:success)
    end

    it 'グループを二重で作成できない' do
      auth_tokens = sign_in(user_a)

      # ユーザーAとユーザーBのグループを作る
      post '/api/v1/groups', params: { user_id: user_b.id }, headers: auth_tokens

      # ユーザーAとユーザーBのグループを作るけど、重複するから失敗することを検証する
      post '/api/v1/groups', params: { user_id: user_b.id }, headers: auth_tokens

      # 二重登録しようとした時の返却メッセージを保存
      json = response.parsed_body['message']

      # 期待している返却メッセージを保存
      message = 'Requested group already exists'

      # メッセージが同一かどうかを検証する
      expect(json).to eq(message)
    end

    it 'グループ一覧を取得する' do
      auth_tokens = sign_in(user_a)

      # ユーザーAとユーザーBのグループを作る
      post '/api/v1/groups', params: { user_id: user_b.id }, headers: auth_tokens

      # グループ一覧を取得
      get '/api/v1/groups', headers: auth_tokens

      # 取得した一覧データのうち必要なグループデータ部分だけを抜粋
      json = response.parsed_body['data']['groups']

      # 取得したグループ数が先に作成したグループ1件分であることを検証する
      expect(json.length).to eq(1)

      expect(response).to have_http_status(:success)
    end
  end
end
