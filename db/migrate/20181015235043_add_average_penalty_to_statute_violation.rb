class AddAveragePenaltyToStatuteViolation < ActiveRecord::Migration[5.1]
  def change
    add_column :statute_violation_matches, :average_penalty, :float
  end
end
