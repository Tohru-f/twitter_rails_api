# frozen_string_literal: true

module Api
  module V1
    class FavoritesController < ApplicationController
      def create
        @favorite = current_api_v1_user.favorites.build(tweet_id: params[:id])
        tweet = Tweet.find(params[:id])
        if @favorite.save
          # 通知機能を呼び出し
          tweet.create_notification!(current_api_v1_user, 'favorite', user_id: tweet.user.id)
          render json: { status: 'SUCCESS', message: 'Favorite successfully saved', data: { id: @favorite.id } }
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
