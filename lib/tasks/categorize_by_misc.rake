require 'spreadsheet'
require 'set'

namespace :categorize_by_misc do

  # looks for facilities without a naics code, but with a sic code
  # that starts with "9"
  task gov_sic: :environment do
    set = Set.new
    counter = 0

    fac_with_sic_codes = File.join(Rails.root.join("lib", "tasks", "files", "gov_with_sic.xls"))
    workbook = Spreadsheet.open(fac_with_sic_codes)
    sheet = workbook.worksheet(0)

    sheet.each do |item|
      set.add(item[0].to_i)
    end

    Facility.pluck(:registry_id).each do |id|
      if set.include?(id)
        f = Facility.find_by_registry_id(id)
        f.fac_type = "gov"
        f.save
        counter += 1
      end
    end

    puts "#{counter} facilities marked as 'gov' type."
  end

  task count_gov_words: :environment do
    counter = Hash.new(0)

    Facility.where(fac_type: 'gov').pluck(:fac_name).each do |name|
      words = name.split(" ")
      words.each { |word| counter[word] += 1 }
    end

    puts counter.sort_by { |k, v| -v }[0..750].map { |pair| "'#{pair.first}'," }
  end

  task count_gov_2_words: :environment do
    counter = Hash.new(0)

    Facility.where(fac_type: 'gov').pluck(:fac_name).each do |name|
      words = name.split(" ").each_cons(2).map { |word| word.join(" ") }
      words.each { |word| counter[word] += 1 }
    end

    puts counter.sort_by { |k, v| -v }[0..1000].map { |pair| "'#{pair.first}'," }
  end

  task count_3_words: :environment do
    counter = Hash.new(0)

    Facility.where(fac_type: 'gov').pluck(:fac_name).each do |name|
      words = name.split(" ").each_cons(3).map { |word| word.join(" ") }
      words.each { |word| counter[word] += 1 }
    end

    puts counter.sort_by { |k, v| -v }[0..200].map { |pair| "'#{pair.first}'," }
  end
end
