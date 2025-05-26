# frozen_string_literal: true

class AddPhoneNumberToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :phone_number, :string, null: false, unique: true, default: ''
  end
end
