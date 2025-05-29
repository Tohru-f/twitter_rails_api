# frozen_string_literal: true

module Api
  module V1
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      private

      def sign_up_params
        params.require(:registration).permit(:name, :email, :phone_number, :birthday, :password, :password_confirmation)
      end
    end
  end
end
