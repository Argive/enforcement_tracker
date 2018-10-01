class FixActivityIdUnique < ActiveRecord::Migration[5.1]
  def change
    change_column :case_enforcements, :activity_id, :bigint, unique: true
  end
end
