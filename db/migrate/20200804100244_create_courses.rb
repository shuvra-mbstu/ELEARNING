class CreateCourses < ActiveRecord::Migration[6.0]
  def up
    create_table :courses do |t|
      t.string :title, null: false, index: { unique: true }

      t.timestamps null: false
    end
  end

  def down
    drop_table :courses
  end
end
