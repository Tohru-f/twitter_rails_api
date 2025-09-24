# frozen_string_literal: true

module Api
  module V1
    class SessionsController < DeviseTokenAuth::SessionsController
      def render_create_success
        user = resource || current_api_v1_user
        passive_notifications_json = user.passive_notifications.as_json(only: %i[id visitor_id visited_id tweet_id comment_id action checked created_at])
        render json: {
          status: 'success',
          data: resource_data(user),
          additional_info: {
            passive_notifications: passive_notifications_json
          }
        }, status: :ok
      end
    end
  end
end
