# frozen_string_literal: true

module Api
  module V1
    class LoginUsersController < ApplicationController
      def show
        render json: { status: 'SUCCESS', message: 'Have gotten user info', data: { user: current_api_v1_user } },
               include: [{ tweets: { methods: %i[image_urls], include: { user: { methods: %i[header_urls icon_urls] } } } },
                         comments: { include: { user: { methods: %i[header_urls icon_urls] } } }]
      end

      def update
        if current_api_v1_user.update(login_user_params)
          # パラメーターにimage_idsが含まれている場合、アップロードされたデータであるBlobから該当のidを持つデータを取得
          # 取得した画像データをツイートに紐づける
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

      private

      def login_user_params
        params.require(:login_user).permit(:name, :profile, :location, :website, :birthday, :header, :icon)
      end
    end
  end
end
