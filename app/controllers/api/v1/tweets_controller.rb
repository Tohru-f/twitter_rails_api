# frozen_string_literal: true

module Api
  module V1
    class TweetsController < ApplicationController
      before_action :set_user, only: %i[create]
      before_action :authenticate_api_v1_user!, only: %i[create]
      before_action :set_tweet, only: %i[show]

      def index
        limit_params = params[:limit]&.to_i
        offset_params = params[:offset]&.to_i
        @tweets = Tweet.all.order(created_at: 'DESC').limit(limit_params).offset(offset_params)
        render json: { stats: 'SUCCESS', message: 'Have gotten all tweets', data: { tweets: @tweets, count: Tweet.all.count } }, include: [:user]
      end

      def show
        render json: { status: 'SUCCESS', message: 'Have gotten requested tweet', data: { tweet: @tweet } }, include: [:user]
      end

      def create
        # current_userに紐づけてtweetを生成する
        @tweet = @user.tweets.new(tweet_params)
        if @tweet.save
          # パラメーターにimage_idsが含まれている場合、アップロードされたデータであるBlobから該当のidを持つデータを取得
          # 取得した画像データをツイートに紐づける
          if params[:tweet][:image_ids]
            blobs = ActiveStorage::Blob.where(id: params[:tweet][:image_ids])
            @tweet.images.attach(blobs)
          end
          render json: { status: 'SUCCESS', message: 'Saved tweet', data: { id: @tweet.id, content: @tweet.content, images: @tweet.image_urls } }
        else
          render json: { status: 'ERROR', message: 'Tweet not saved', data: @tweet.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def tweet_params
        params.require(:tweet).permit(:user_id, :content)
      end

      def set_user
        # current_userを取得して変数に代入。apiモードではcurrent_api_v1_userと記述する
        @user = User.find(current_api_v1_user.id)
      end

      def set_tweet
        @tweet = Tweet.find(params[:id])
      end
    end
  end
end
