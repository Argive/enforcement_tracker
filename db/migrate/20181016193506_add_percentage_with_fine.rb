class AddPercentageWithFine < ActiveRecord::Migration[5.1]
  def change
    add_column :statute_violation_matches, :percentage_with_fine, :float
  end
end


# StatuteViolationMatch.find_each do |s|
#   next if s.violations_with_no_fine.nil? || s.count.nil?
#   result = 1 - (s.violations_with_no_fine / s.count.to_f)
#   s.percentage_with_fine = result
#   s.save
# end
