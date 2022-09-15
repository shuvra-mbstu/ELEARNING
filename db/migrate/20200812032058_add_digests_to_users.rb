class AddDigestsToUsers < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :password_digest, :string, null: false
    add_column :users, :remember_digest, :string
  end

  def down
    remove_column :users, :password_digest
    remove_column :users, :remember_digest
  end
end
