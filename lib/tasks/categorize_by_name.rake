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

    VALID_CHARS = ("A".."Z").to_a + ("0".."9").to_a + [" ", "'", "-"]

    raw_data_sheet.each_with_index 2 do |item, idx|

      punc_removed_item = item[0].upcase.split("").select { |char| VALID_CHARS.include?(char) }
      punc_removed_sheet[idx, 0] = punc_removed_item.join
    end

    punc_removed_book.write(punc_removed_file)
  end

  task remove_common_large: :environment do
    punc_removed_file = File.join(Rails.root.join("lib", "tasks", "files", "public_companies", "punc_removed.xls"))
    punc_removed_book = Spreadsheet.open(punc_removed_file)
    punc_removed_sheet = punc_removed_book.worksheet(0)

    final_file = File.join(Rails.root.join("lib", "tasks", "files", "public_companies", "final.xls"))
    final_book = Spreadsheet::Workbook.new
    final_sheet = final_book.create_worksheet

    word_counter = Hash.new(0)

    punc_removed_sheet.each do |item|
      item[0].split(" ").each { |word| word_counter[word] += 1 }
    end

    word_counter.sort_by { |k, v| -v }[0..250].map { |pair| "'#{pair.first}',"}

    COMMON_WORDS = [
      # 'OF',
      # 'AND',
      # 'THE',
      # '&',
      # '-',
      # ',',
      # ', '
    ]

    punc_removed_sheet.each_with_index do |item, idx|
      words_removed_item = item[0].split(" ").select { |word| !COMMON_WORDS.include?(word) }
      final_sheet[idx, 0] = words_removed_item.join(" ")
    end

    final_book.write(final_file)
  end

  task remove_common_sp: :environment do
    s_p_file = File.join(Rails.root.join("lib", "tasks", "files", "public_companies", "s_p.xls"))
    s_p_book = Spreadsheet.open(s_p_file)
    s_p_sheet = s_p_book.worksheet(0)

    s_p_cleaned_file = File.join(Rails.root.join("lib", "tasks", "files", "public_companies", "s_p_cleaned.xls"))
    s_p_cleaned_book = Spreadsheet::Workbook.new
    s_p_cleaned_sheet = s_p_cleaned_book.create_worksheet

    word_counter = Hash.new(0)

    s_p_sheet.each do |item|
      item[0].split(" ").each { |word| word_counter[word] += 1 }
    end

    word_counter.sort_by { |k, v| -v }[0..20].map { |pair| puts "'#{pair.first}',"}

    COMMON_WORDS = [
      'Inc.',
      'Corp.',
      'Inc',
      '&',
      'Group',
      'Corporation',
      'Corp',
      'Co.',
      'Company',
      'International',
      'Holdings',
      'Co',
      'Ltd.',
      'The',
      '(The)'
    ]

    idx = 0
    s_p_sheet.each do |item|
      words_removed_item = item[0].split(" ").select { |word| !COMMON_WORDS.include?(word) }.join(" ")

      if words_removed_item.length > 4

        if words_removed_item[-1] == ","
          s_p_cleaned_sheet[idx, 0] = words_removed_item[0...-1].upcase
        else
          s_p_cleaned_sheet[idx, 0] = words_removed_item.upcase
        end
        idx += 1
      end
    end

    s_p_cleaned_book.write(s_p_cleaned_file)
  end

  # task remove_short_names: :environment do
  #   final_file = File.join(Rails.root.join("lib", "tasks", "files", "public_companies", "final.xls"))
  #   final_book = Spreadsheet.open(final_file)
  #   final_sheet = final_book.worksheet(0)
  #
  #   final_file_short_removed = File.join(Rails.root.join("lib", "tasks", "files", "public_companies", "final_short_removed.xls"))
  #   final_book_short_removed = Spreadsheet::Workbook.new
  #   final_sheet_short_removed = final_book_short_removed.create_worksheet
  #
  #   idx = 0
  #
  #   final_sheet.each do |item|
  #     next if item[0].nil?
  #     if item[0].length > 4
  #       final_sheet_short_removed[idx, 0] = item[0]
  #       idx += 1
  #     else
  #       puts "#{item[0]} removed."
  #     end
  #   end
  #
  #   final_book_short_removed.write(final_file_short_removed)
  # end

  task s_p: :environment do
    s_p_cleaned = File.join(Rails.root.join("lib", "tasks", "files", "public_companies", "s_p_cleaned.xls"))
    s_p_book = Spreadsheet.open(s_p_cleaned)
    s_p_sheet = s_p_book.worksheet(0)

    counter = 0

    s_p_companies = Set.new
    s_p_sheet.each do |item|
      s_p_companies.add(item[0])
    end

    s_p_companies.each do |known_large|
      next if known_large.nil?

      matches = Facility.where(fac_type: 'large').where('fac_name LIKE ?', "%#{known_large}%")

      # p "#{known_large}: #{matches.count}"
      matches.each do |match|
        p match.fac_name
        match.fac_type = 'large'
        match.save
        counter += 1
      end
    end

    puts "#{counter} facilities marked as large."
  end

  # false positives from s&p (remove later):
  FALSE_POSITIVES_S_P = [
    'ALBEMARLE',
    'APPLE',
    'HARRIS',
    'PAPER',
    'SOUTHERN',
    'TARGET'
  ]

  task large: :environment do
    final_file = File.join(Rails.root.join("lib", "tasks", "files", "public_companies", "final.xls"))
    final_book = Spreadsheet.open(final_file)
    final_sheet = final_book.worksheet(0)

    counter = 0

    public_companies = Set.new
    final_sheet.each do |item|
      public_companies.add(item[0])
    end

    Facility.where(fac_type: nil).pluck(:id, :fac_name).each do |f|
      next if f[1].nil?

      facility_name = f[1].split(" ")

      public_companies.each do |p|
        next if p.nil?

        public_company_name = p.split(" ")

        if public_company_name[0] == facility_name[0] && (public_company_name & facility_name).length > 2
          large_f = Facility.find(f[0])
          large_f.fac_type = 'large'
          large.save

          puts "#{p.split(" ")}: #{facility_name}"
          counter += 1
          break
        end
      end

    end

    # public_companies.each do |known_large|
    #   next if known_large.nil?
    #
    #   matches = Facility.where(fac_type: nil).where('fac_name LIKE ?', "%#{known_large}%")
    #
    #   if matches.length > 10
    #     p "#{known_large}: #{matches.pluck(:fac_name).to_a}"
    #     p "------------------------------------------------"
    #     puts
    #     puts
    #   end
    #
    #   matches_count = matches.to_a.count
    #
    #   counter += matches_count
    #
    #   p matches_count
    # end

    puts "#{counter} facilities marked as large."
  end
end
