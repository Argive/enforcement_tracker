class ChangeActivityIdToBigintInStatutes < ActiveRecord::Migration[5.1]
  def change
    change_column :case_statutes, :activity_id, :bigint
  end
end
