# frozen_string_literal: true

require 'rails_helper'
require 'pry'

RSpec.describe 'Api::V1::Relations' do
  describe '/api/v1/users/:id/follow or unfollow' do
    let(:user_a) { create(:user, name: 'ユーザーA', email: 'a@sample.com', password: 'password', confirmed_at: Time.zone.today) }
    let(:user_b) { create(:user, name: 'ユーザーB', email: 'b@sample.com', password: 'password', confirmed_at: Time.zone.today) }

    it 'ユーザーをフォローする' do
      auth_tokens = sign_in(user_a)

      # フォローした時にRelationモデルの総数が1件増えることを検証する
      expect { post "/api/v1/users/#{user_b.id}/follow", headers: auth_tokens }.to change(Relation, :count).by(+1)

      expect(response).to have_http_status(:success)
    end

    it 'フォローを解除する' do
      auth_tokens = sign_in(user_a)

      relation = create(:relation, user: user_a, follower: user_b)

      # 事前に作ったフォローデータを削除することでRelationモデルの総数が1件減ることを検証する
      expect { delete "/api/v1/users/#{relation.follower_id}/unfollow", headers: auth_tokens }.to change(Relation, :count).by(-1)

      expect(response).to have_http_status(:success)
    end
  end
end
