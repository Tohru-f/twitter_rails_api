# frozen_string_literal: true

module Api
  module V1
    class GroupsController < ApplicationController
      def index
        @groups = current_api_v1_user.groups

        render json: { status: 'SUCCESS', message: 'have gotten all requested groups', data: { groups: @groups } }, include: [{ users: { methods: %i[header_urls icon_urls] } }, :messages]
      end

      def create
        # 受け取ったidとログインユーザーのグループが既に存在する場合は二重作成にならないように処理中断
        if check_groups(params[:user_id])
          render json: { status: 'ERROR', message: 'Requested group already exists', data: { group: @group } }
          return
        end
        @group = Group.create
        @entrie = @group.entries.build(user_id: params[:user_id])
        @login_user_entrie = @group.entries.build(user_id: current_api_v1_user.id)

        if @entrie.save && @login_user_entrie.save
          render json: { status: 'SUCCESS', message: 'Group successfully saved', data: { group: @group } }
        else
          render json: { status: 'ERROR', message: 'Group not saved' }
        end
      end

      private

      def check_groups(_id)
        @group = Group.joins(:entries).where(entries: { user_id: [current_api_v1_user.id, params[:user_id]] }).group('groups.id').having('COUNT(entries.id) = 2')
        @group.exists?
      end
    end
  end
end
