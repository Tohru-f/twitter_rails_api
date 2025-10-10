# frozen_string_literal: true

module Api
  module V1
    class SessionsController < DeviseTokenAuth::SessionsController
      def destroy
        client_id = request.headers['client']
        uid = request.headers['uid']
        request.headers['access-token']

        # 論理削除されたユーザーも含むようにwith_discardedを加える
        @user = User.with_discarded.find_by(uid:)

        # トークンはclien_idごとに管理されているので、client_idをキーとしてトークンを探す
        if @user && @user.tokens[client_id]

          # deleteすることでトークン情報のみを全て削除できる
          @user.tokens.delete(client_id)

          # トークン情報を削除した状態で保存
          @user.save!
          render json: { status: 'SUCCESS', message: 'have logged out successfully' }
        else
          render json: { status: 'ERROR', message: 'User not found' }
        end
      end
    end
  end
end
