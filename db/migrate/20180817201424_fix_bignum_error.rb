class FixBignumError < ActiveRecord::Migration[5.1]
  def change
    change_column :facilities, :fac_total_penalties, :bigint
    change_column :facilities, :fac_last_penalty_amount, :bigint
    change_column :facilities, :caa_penalties, :bigint
    change_column :facilities, :cwa_penalties, :bigint
    change_column :facilities, :rcra_penalties, :bigint

  end
end
