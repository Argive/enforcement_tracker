namespace :categorize_by_naics do
  task gov: :environment do
    facilities = Facility.where('fac_naics_codes like ? OR fac_naics_codes like ?',  "92%", "% 92%")
    counter = 0

    facilities.each do |f|
      f.fac_type = "gov"
      f.save
      counter += 1
    end

    puts "#{counter} facilities marked as 'gov' type."
  end
end
