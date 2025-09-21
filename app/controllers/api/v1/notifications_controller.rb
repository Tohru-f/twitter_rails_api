# frozen_string_literal: true

module Api
  module V1
    class NotificationsController < ApplicationController
      def index
        @notifications = current_api_v1_user.passive_notifications

        render json: { status: 'SUCCESS', message: 'have gotten notification info successfully', data: { notifications: @notifications } },
               include: [{ visitor: { methods: %i[header_urls icon_urls] } }, :tweet]

        # 一覧データを表示した時にchecked部分をfalseからtrueに変更することで通知データを確認したこととする。
        @notifications.where(checked: false).each do |notification|
          notification.update(checked: true)
        end
      end
    end
  end
end
