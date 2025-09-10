# frozen_string_literal: true

class ChangeColumnSettingFromFavorites < ActiveRecord::Migration[7.0]
  def up; end

  def down
    remove_index :favorites, column: :user_id
    remove_index :favorites, column: :tweet_id
  end
end
