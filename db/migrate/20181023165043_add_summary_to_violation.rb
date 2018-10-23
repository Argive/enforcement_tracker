class AddSummaryToViolation < ActiveRecord::Migration[5.1]
  def change
    add_column :statute_violation_matches, :summary, :text
  end
end
