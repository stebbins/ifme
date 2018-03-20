class AddBannedtoUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :banned, :boolean, default: false
    add_column :users, :banned_at, :datetime
    add_column :users, :admin, :boolean, default: false 
  end
end
