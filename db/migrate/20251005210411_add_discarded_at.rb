# frozen_string_literal: true

class AddDiscardedAt < ActiveRecord::Migration[7.0]
  def change
    add_column :retweets, :discarded_at, :datetime
    add_index :retweets, :discarded_at

    add_column :relations, :discarded_at, :datetime
    add_index :relations, :discarded_at

    add_column :notifications, :discarded_at, :datetime
    add_index :notifications, :discarded_at

    add_column :messages, :discarded_at, :datetime
    add_index :messages, :discarded_at

    add_column :groups, :discarded_at, :datetime
    add_index :groups, :discarded_at

    add_column :favorites, :discarded_at, :datetime
    add_index :favorites, :discarded_at

    add_column :entries, :discarded_at, :datetime
    add_index :entries, :discarded_at

    add_column :comments, :discarded_at, :datetime
    add_index :comments, :discarded_at

    add_column :bookmarks, :discarded_at, :datetime
    add_index :bookmarks, :discarded_at

    add_column :tweets, :discarded_at, :datetime
    add_index :tweets, :discarded_at
  end
end
