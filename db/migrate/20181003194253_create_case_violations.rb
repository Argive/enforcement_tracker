class CreateCaseViolations < ActiveRecord::Migration[5.1]
  def change
    create_table :case_violations do |t|
      t.bigint :activity_id 
      t.string :violation_type_code
      t.integer :rank_order
      t.string :violation_type_desc

      t.timestamps
    end
  end
end
