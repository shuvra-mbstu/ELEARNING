class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    enable_extension 'citext'

    create_table :users do |t|
      t.citext :username, null: false, index: { unique: true }
      t.citext :email, null: false, index: { unique: true }
      t.string :full_name, null: false
      t.string :location
      t.boolean :admin, default: false

      t.timestamps null: false
    end
  end
end
