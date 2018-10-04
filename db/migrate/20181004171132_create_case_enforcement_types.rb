class CreateCaseEnforcementTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :case_enforcement_types do |t|
      t.bigint :activity_id
      t.string :enf_type_code
      t.string :enf_type_desc
      
      t.timestamps
    end
  end
end
