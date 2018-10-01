class MakeEnforcementActivityIdUnique < ActiveRecord::Migration[5.1]
  def change
    add_index :case_enforcements, :activity_id, unique: true, name: 'activity_id'
  end
end
