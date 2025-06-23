# frozen_string_literal: true

module Api
  module V1
    class OmniauthCallbacksController < ApplicationController
      def redirect_callbacks
        auth = request.env['omniauth.auth']
        return if auth.nil?

        # request.env['omniauth.auth']にリクエストパラメーターにユーザー情報が入ってくる
        user = User.from_omniauth(request.env['omniauth.auth'])
        if user.persisted?
          # create_new_auth_tokenでトークン情報を全て生成する
          token = user.create_new_auth_token
          if user.save
            # フロントエンド側でトークン情報を取得できるようにURLにパラメーター内にトークン情報を入れる
            redirect_to "http://localhost:5173?status=success&access-token=#{token['access-token']}&uid=#{user.uid}&client=#{token['client']}&expiry=#{token['expiry']}"
          end
        else
          render json: { status: 'ERROR', message: '401 Unauthorized', data: user.errors }, status: :unprocessable_entity
        end
      end
    end
  end
end
