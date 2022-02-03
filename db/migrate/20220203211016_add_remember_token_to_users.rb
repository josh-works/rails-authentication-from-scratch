require 'securerandom'

class AddRememberTokenToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :remember_token, :string, null: false, default: ""
    User.find_each do |u|
      u.update_columns(remember_token: SecureRandom.hex)
    end
    add_index :users, :remember_token, unique: true
  end
end
