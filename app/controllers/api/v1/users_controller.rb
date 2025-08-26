# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: %i[show]

      def show
        @tweets = @user.tweets.order(created_at: 'DESC')
        render json: { status: 'SUCCESS', message: "Have gotten user's tweets", data: { tweets: @tweets } },
               include: { user: { methods: %i[header_urls icon_urls], include: :tweets } }
      end

      private

      def set_user
        # current_userを取得して変数に代入。apiモードではcurrent_api_v1_userと記述する
        @user = User.find(params[:id])
      end
    end
  end
end
