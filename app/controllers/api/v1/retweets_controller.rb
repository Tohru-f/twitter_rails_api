# frozen_string_literal: true

module Api
  module V1
    class RetweetsController < ApplicationController
      def create
        @retweet = current_api_v1_user.retweets.build(tweet_id: params[:id])
        if @retweet.save
          render json: { status: 'SUCCESS', message: 'Retweet successfully saved', data: { ID: @retweet.id } }
        else
          render json: { status: 'ERROR', message: 'Retweet not saved' }
        end
      end

      def destroy
        @retweet = current_api_v1_user.retweets.find_by(tweet_id: params[:id])
        if @retweet.destroy!
          render json: { status: 'SUCCESS', message: 'Retweet successfully deleted' }
        else
          render json: { status: 'ERROR', message: 'Retweet not deleted' }
        end
      end
    end
  end
end
