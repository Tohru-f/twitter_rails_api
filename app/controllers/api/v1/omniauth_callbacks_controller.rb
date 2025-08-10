# frozen_string_literal: true

module Api
  module V1
    class OmniauthCallbacksController < ApplicationController
      def redirect_callbacks
        auth = request.env['omniauth.auth']
        return if auth.nil?

        # request.env['omniauth.auth']にリクエストパラメーターのユーザー情報が入ってくる
        user = User.from_omniauth(request.env['omniauth.auth'])
        if user.persisted?
          # create_new_auth_tokenでトークン情報を全て生成する
          token = user.create_new_auth_token
          if user.save
            # フロントエンド側でトークン情報を取得できるようにURLにパラメーター内にトークン情報を入れる
            redirect_to "http://localhost:5173?status=success&access-token=#{token['access-token']}&uid=#{user.uid}&client=#{token['client']}&expiry=#{token['expiry']}&login_userid=#{user.id}&name=#{user.name}&profile=#{user.profile}&location=#{user.location}&website=#{user.website}&birthday=#{user.birthday}",
                        allow_other_host: true
            # パラメーターに他のユーザー情報を追加して取得できるようにする
          end
        else
          render json: { status: 'ERROR', message: '401 Unauthorized', data: user.errors }, status: :unprocessable_entity
        end
      end
    end
  end
end
