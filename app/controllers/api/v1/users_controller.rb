# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: %i[show update]

      def show
        @tweets = @user.tweets.order(created_at: 'DESC')
        render json: { status: 'SUCCESS', message: "Have gotten user's tweets", data: { tweets: @tweets } },
               include: { user: { methods: %i[header_urls icon_urls], include: :tweets } }
      end

      def update
        if current_api_v1_user.update(user_params)
          # パラメーターにimage_idsが含まれている場合、アップロードされたデータであるBlobから該当のidを持つデータを取得
          # 取得した画像データをツイートに紐づける
          # binding.pry
          if params[:header_id].count.positive?
            blobs = ActiveStorage::Blob.find(params[:header_id].first)
            current_api_v1_user.header.attach(blobs)
          end
          if params[:icon_id].count.positive?
            blobs = ActiveStorage::Blob.find(params[:icon_id].first)
            current_api_v1_user.icon.attach(blobs)
          end
          render json: { status: 'SUCCESS', message: 'Successfully updated',
                         data: { user: current_api_v1_user, header: current_api_v1_user.header_urls, icon: current_api_v1_user.icon_urls } }
        else
          render json: { status: 'ERROR', message: 'UserInfo not saved', data: current_api_v1_user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def info
        render json: { status: 'SUCCESS', message: 'Have gotten user info', data: { user: current_api_v1_user } }
      end

      private

      def set_user
        # current_userを取得して変数に代入。apiモードではcurrent_api_v1_userと記述する
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:name, :profile, :location, :website, :birthday, :header, :icon)
      end
    end
  end
end
