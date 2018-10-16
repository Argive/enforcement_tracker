class AddViolationsWithNoFine < ActiveRecord::Migration[5.1]
  def change
    add_column :statute_violation_matches, :violations_with_no_fine, :integer
  end
end
