class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.integer :violation_id, null: false
      t.string :commenter_name, null: false
      t.string :body, null: false
      t.timestamps
    end
  end
end
