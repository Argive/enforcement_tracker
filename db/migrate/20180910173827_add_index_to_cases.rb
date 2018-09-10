class AddIndexToCases < ActiveRecord::Migration[5.1]
  def change
    add_index :case_enforcements, :activity_id
    add_index :case_statutes, :activity_id
  end
end
