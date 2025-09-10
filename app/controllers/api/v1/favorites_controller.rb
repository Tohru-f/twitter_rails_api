# frozen_string_literal: true

module Api
  module V1
    class FavoritesController < ApplicationController
      def create
        @favorite = current_api_v1_user.favorites.build(tweet_id: params[:id])

        if @favorite.save
          render json: { status: 'SUCCESS', message: 'Favorite successfully saved', data: { ID: @favorite.id } }
        else
          render json: { status: 'ERROR', message: 'Favorite not saved' }
        end
      end

      def destroy
        @favorite = current_api_v1_user.favorites.find_by(tweet_id: params[:id])
        if @favorite.destroy
          render json: { status: 'ERROR', message: 'Favorite successfully deleted' }
        else
          render json: { status: 'ERROR', message: 'Favorite not deleted' }
        end
      end
    end
  end
end
