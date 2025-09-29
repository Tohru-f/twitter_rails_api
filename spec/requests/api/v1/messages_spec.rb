# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Messages' do
  describe 'api/v1/groups/:id/messages' do
    let(:user_a) { create(:user, name: 'ユーザーA', email: 'a@sample.com', password: 'password', confirmed_at: Time.zone.today) }
    let(:user_b) { create(:user, name: 'ユーザーB', email: 'b@sample.com', password: 'password', confirmed_at: Time.zone.today) }

    it 'メッセージを作成する' do
      auth_tokens = sign_in(user_a)

      # 事前準備としてグループを作成
      post '/api/v1/groups', params: { user_id: user_b.id }, headers: auth_tokens

      # 返却されたデータからグループidを取得
      group_id = response.parsed_body['data']['group']['id']

      # グループにメッセージを投稿して全体数が1件増えたかどうかを検証する
      expect { post "/api/v1/groups/#{group_id}/messages", params: { content: 'テスト' }, headers: auth_tokens }.to change(Message, :count).by(+1)
    end

    it 'メッセージを取得する' do
      auth_tokens = sign_in(user_a)

      # 事前準備としてグループを作成
      post '/api/v1/groups', params: { user_id: user_b.id }, headers: auth_tokens

      # 返却されたデータからグループidを取得
      group_id = response.parsed_body['data']['group']['id']

      # グループにメッセージを投稿する
      post "/api/v1/groups/#{group_id}/messages", params: { content: 'テスト1' }, headers: auth_tokens

      # グループにメッセージを投稿する
      post "/api/v1/groups/#{group_id}/messages", params: { content: 'テスト2' }, headers: auth_tokens

      # グループのメッセージを全て取得する
      get "/api/v1/groups/#{group_id}/messages", headers: auth_tokens

      # 取得したデータからメッセージ部分を抜粋する
      json = response.parsed_body['data']['messages']

      # 取得したメッセージ数が期待した数量と一致することを検証する
      expect(json.length).to eq(2)

      expect(response).to have_http_status(:success)
    end
  end
end
