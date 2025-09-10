# frozen_string_literal: true

class RemoveNumberFromRetweet < ActiveRecord::Migration[7.0]
  def change
    remove_column :retweets, :number, :integer
  end
end
