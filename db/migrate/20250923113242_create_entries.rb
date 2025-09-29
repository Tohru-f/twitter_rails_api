# frozen_string_literal: true

class CreateEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :entries do |t|
      t.references :user, null: false, foreign_key: true
      t.references :group, null: false, foreign_key: true

      t.timestamps
      # 複合ユニークの実装。1つのグループに同じユーザーは一人しか居ない
      t.index %i[group_id user_id], unique: true
    end
  end
end
