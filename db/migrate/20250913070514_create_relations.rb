# frozen_string_literal: true

class CreateRelations < ActiveRecord::Migration[7.0]
  def change
    create_table :relations do |t|
      t.references :user, null: false, foreign_key: true, index: false
      t.references :follower, null: false, foreign_key: { to_table: :users }, index: false

      t.timestamps
      t.index %i[user_id follower_id], unique: true
    end
  end
end
