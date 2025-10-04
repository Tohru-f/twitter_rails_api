# frozen_string_literal: true

module Api
  module V1
    class RetweetsController < ApplicationController
      def create
        @retweet = current_api_v1_user.retweets.build(tweet_id: params[:id])
        tweet = Tweet.find(params[:id])
        if @retweet.save
          # 通知機能呼び出し
          tweet.create_notification!(current_api_v1_user, 'retweet', user_id: tweet.user.id)
          render json: { status: 'SUCCESS', message: 'Retweet successfully saved', data: { retweet: @retweet } }, include: { user: { methods: %i[header_urls icon_urls] } }
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
