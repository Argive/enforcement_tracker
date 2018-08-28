require_relative './files/gov_keywords'
require 'spreadsheet'

namespace :categorize_by_name do
  task gov: :environment do
    counter = 0

    Facility.where(fac_naics_codes: nil).pluck(:id, :fac_name).each do |id_name|
      next if id_name[1].nil?

      id_name[1].split(" ").each do |word|
        if GOV_SINGLE_WORDS.include?(word)
          puts id_name[1]
          f = Facility.find(id_name[0])
          f.fac_type = "gov"
          f.save
          counter += 1
          break
        end
      end

    end

    puts "#{counter} facilities marked as 'gov' type."
  end

  task remove_punc_large: :environment do
    raw_data_file = File.join(Rails.root.join("lib", "tasks", "files", "public_companies", "raw_data.xls"))
    raw_data_book = Spreadsheet.open(raw_data_file)
    raw_data_sheet = raw_data_book.worksheet(0)

    punc_removed_file = File.join(Rails.root.join("lib", "tasks", "files", "public_companies", "punc_removed.xls"))
    punc_removed_book = Spreadsheet::Workbook.new
    punc_removed_sheet = punc_removed_book.create_worksheet

    VALID_CHARS = ("A".."Z").to_a + ("0".."9").to_a + [" "]

    raw_data_sheet.each_with_index 2 do |item, idx|

      punc_removed_item = item[0].upcase.split("").select { |char| VALID_CHARS.include?(char) }
      punc_removed_sheet[idx, 0] = punc_removed_item.join
    end

    punc_removed_book.write(punc_removed_file)
  end

  task remove_common_large: :environment do
    punc_removed_file = File.join(Rails.root.join("lib", "tasks", "files", "public_companies", "punc_removed.xls"))
    punc_removed_book = Spreadsheet.open(punc_removed_file)
    punc_removed_sheet = punc_removed_book(0)
  end
end
