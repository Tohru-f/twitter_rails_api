# frozen_string_literal: true

module Api
  module V1
    class ImagesController < ApplicationController
      def create
        files = params[:files]
        # filesが配列になっていなかったら配列に変換。map関数に対応できるように。
        files = [files] unless files.is_a?(Array)
        # ActiveStorageにファイル(io)とファイル名を渡すことでファイルがアップロードされ、ActiveStorage::Blob(ファイルに関するデータ)が返却される
        # original_filenameメソッドを使うことでアップロードされたファイルの「元のファイル名」を取得する
        # 最終的に{ id: blob.id, url: url_for(blob) }の行でidとurlのハッシュを返しているので、ハッシュの配列がblobsに入る
        blobs = files.map do |file|
          blob = ActiveStorage::Blob.create_and_upload!(io: file, filename: file.original_filename)
          { id: blob.id, url: url_for(blob) }
        end
        render json: { blobs: }
      end
    end
  end
end
