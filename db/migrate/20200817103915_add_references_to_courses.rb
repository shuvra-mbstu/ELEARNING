class AddReferencesToCourses < ActiveRecord::Migration[6.0]
  def up
    add_reference :courses, :category, foreign_key: true
    add_reference :courses, :author, null: false, foreign_key: { to_table: :users }
  end

  def down
    remove_reference :courses, :category, foreign_key: true
    remove_reference :courses, :author, foreign_key: { to_table: :users }
  end
end
