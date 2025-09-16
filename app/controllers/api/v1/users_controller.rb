# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: %i[show create destroy]

      def show
        @tweets = @user.tweets.order(created_at: 'DESC')
        @comments = @user.comments.order(created_at: 'DESC')
        render json: { status: 'SUCCESS', message: "Have gotten user's tweets", data: { tweets: @tweets, comments: @comments } },
               include: { user: { methods: %i[header_urls icon_urls], include: :tweets } }
      end

      def create
        @follow = current_api_v1_user.relations.build(follower_id: @user.id)
        if @follow.save
          render json: { status: 'SUCCESS', message: 'Have created relation successfully', data: { id: @follow.id } }
        else
          render json: { status: 'ERROR', message: 'Relation not saved' }
        end
      end

      def destroy
        @follow = current_api_v1_user.relations.find_by(follower_id: @user.id)
        if @follow.destroy
          render json: { status: 'SUCCESS', message: 'Have deleted relation successfully' }
        else
          render json: { status: 'ERROR', message: 'Relation not deleted' }
        end
      end

      private

      def set_user
        # current_userを取得して変数に代入。apiモードではcurrent_api_v1_userと記述する
        @user = User.find(params[:id])
      end
    end
  end
end
