# frozen_string_literal: true

module Api
  module V1
    class MessagesController < ApplicationController
      def index
        @messages = Message.where(group_id: params[:group_id])
        render json: { status: 'SUCCESS', messages: "have gotten all group's messages", data: { messages: @messages } }, include: :user
      end

      def create
        @group = Group.find(params[:group_id])
        @message = @group.messages.build(user_id: current_api_v1_user.id, content: params[:content])

        if @message.save
          render json: { status: 'SUCCESS', message: 'Message saved successfully', data: { message: @message } }, include: :user
        else
          render json: { status: 'ERROR', message: 'Message not saved' }
        end
      end
    end
  end
end
