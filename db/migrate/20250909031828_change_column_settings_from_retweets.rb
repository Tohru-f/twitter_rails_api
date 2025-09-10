# frozen_string_literal: true

class ChangeColumnSettingsFromRetweets < ActiveRecord::Migration[7.0]
  def up
    add_index :retweets, %i[user_id tweet_id], unique: true
  end

  def down
    # remove_index :retweets, column: :user_id
    # remove_index :retweets, column: :tweet_id
    remove_index :retweets, %i[user_id tweet_id]
  end
end
