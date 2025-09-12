# frozen_string_literal: true

module Api
  module V1
    class CommentsController < ApplicationController
      before_action :set_tweets, only: %i[create]
      before_action :set_comments, only: %i[destroy]

      def index
        @tweet = Tweet.find(params[:id])
        render json: { status: 'SUCCESS', message: 'Have gotten all comments', data: { comments: @tweet.comments } },
               include: { user: { methods: %i[header_urls icon_urls] } }
      end

      def create
        @comment = @tweet.comments.new(comment_params)
        @comment.user = current_api_v1_user
        # binding.pry
        if @comment.save
          render json: { status: 'SUCCESS', message: 'Comment successfully saved', data: { comment: @comment } }
        else
          render json: { status: 'ERROR', message: 'Comment not saved' }
        end
      end

      def destroy
        if @comment.user.id == current_api_v1_user.id
          @comment.destroy!
          render json: { status: 'SUCCESS', message: 'Comment successfully deleted' }
        else
          render json: { status: 'ERROR', message: 'Comment not deleted' }
        end
      end

      private

      def set_comments
        @comment = Comment.find(params[:id])
      end

      def set_tweets
        @tweet = Tweet.find(params[:tweet_id])
      end

      def comment_params
        params.require(:comment).permit(:tweet_id, :content)
      end
    end
  end
end
