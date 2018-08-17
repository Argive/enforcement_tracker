class CreateFacilities < ActiveRecord::Migration[5.1]
  def change
    create_table :facilities do |t|
      t.integer :registry_id, null: false
      t.string :fac_name
      t.string :fac_street
      t.string :fac_city
      t.string :fac_state
      t.integer :fac_zip
      t.integer :fac_epa_region
      t.float :fac_lat
      t.float :fac_long
      t.string :fac_naics_codes

      t.integer :fac_inspection_count
      t.string :fac_date_last_inspection

      t.integer :fac_informal_count
      t.string :fac_date_last_informal_action
      t.integer :fac_formal_action_count
      t.string :fac_date_last_formal_action
      t.integer :fac_total_penalties
      t.integer :fac_penalty_count
      t.string :fac_date_last_penalty
      t.integer :fac_last_penalty_amount

      t.integer :caa_evaluation_count
      t.integer :caa_informal_count
      t.integer :caa_formal_action_count
      t.integer :caa_penalties

      t.integer :cwa_inspection_count
      t.integer :cwa_informal_count
      t.integer :cwa_formal_action_count
      t.integer :cwa_penalties

      t.integer :rcra_inspection_count
      t.integer :rcra_informal_count
      t.integer :rcra_formal_action_count
      t.integer :rcra_penalties

      t.integer :sdwa_informal_count
      t.integer :sdwa_formal_action_count

      t.timestamps
    end

    add_index :facilities, [:registry_id], unique: true
  end
end
