# frozen_string_literal: true

module Api
  module V1
    class BookmarksController < ApplicationController
      def index
        @bookmarks = current_api_v1_user.bookmarks

        render json: { status: 'SUCCESS', message: 'have gotten requested bookmarks successfully', data: { bookmarks: @bookmarks } },
               include: { tweet: { methods: %i[image_urls], include: { user: { methods: %i[header_urls icon_urls] } } } }
      end

      def create
        @bookmark = current_api_v1_user.bookmarks.build(tweet_id: params[:tweet_id])
        # binding.pry
        if @bookmark.save
          render json: { status: 'SUCCESS', message: 'Bookmark have been saved successfully', data: { bookmark: @bookmark } }, include: { user: { methods: %i[header_urls icon_urls] } }
        else
          render json: { status: 'ERROR', message: 'Bookmark not saved' }
        end
      end

      def destroy
        @bookmark = current_api_v1_user.bookmarks.find_by(tweet_id: params[:id])

        if @bookmark.destroy
          render json: { status: 'SUCCESS', message: 'Bookmark successfully deleted' }
        else
          render json: { status: 'ERROR', message: 'Bookmark not deleted' }
        end
      end
    end
  end
end
