class CreateCaseEnforcements < ActiveRecord::Migration[5.1]
  def change
    create_table :case_enforcements do |t|
      t.integer :activity_id
      t.string :activity_name
      t.string :state_code
      t.string :region_code
      t.integer :fiscal_year
      t.string :case_number
      t.string :case_name
      t.string :activity_type_code
      t.string :activity_type_desc
      t.integer :activity_status_code
      t.string :activity_status_desc
      t.date :activity_status_date
      t.string :lead
      t.date :case_status_date
      t.string :doj_docket_nmbr
      t.integer :enf_outcome_code
      t.string :enf_outcome_desc
      t.string :enf_outcome_text
      t.integer :total_penalty_assessed_amt
      t.integer :total_cost_recovery_amt
      t.integer :total_com_action_amt
      t.string :hq_division
      t.string :branch
      t.string :voluntary_self_disclosure_flag
      t.string :multimedia_flag

      t.timestamps
    end
  end
end
