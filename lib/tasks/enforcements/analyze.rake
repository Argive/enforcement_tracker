require 'csv'
require 'spreadsheet'
require_relative 'terminal_output'

namespace :analyze do
  task statute_frequency: :environment do
    counter = Hash.new(0)

    CaseStatute.all.each do |c|
      counter[c.law_section_desc] += 1
      puts c.law_section_desc
    end

    p counter.sort_by { |k, v| -v }[0..50]
  end

  task statute_law: :environment do
    counter = Hash.new(0)

    CaseStatute.all.each do |c|
      counter["#{c.statute_code} #{c.law_section_code} #{c.law_section_desc}"] += 1
    end

    sorted = counter.sort_by { |k, v| -v }

    sorted.each do |k_v|
      puts "#{k_v.first}: #{k_v.last}"
    end
  end

  task common_violations: :environment do
    codes = Hash.new(0)
    descs = Hash.new(0)

    statutes = Hash.new(0)

    map = {}

    CaseViolation.find_each do |v|
      codes[v.violation_type_code] += 1 if v.violation_type_code
      descs["#{v.violation_type_code} - #{v.violation_type_desc}"] += 1 if v.violation_type_desc

      if !map[v.violation_type_code]
        map[v.violation_type_code] = v.violation_type_desc
      end
    end
    counter = 0

    descs.sort_by { |k, v| -v }.each do |desc|
      p desc

      counter += desc.last
    end

    descs

    puts "The counter is #{counter}"
  end

  task enforcements_by_year: :environment do
    counter = Hash.new(0)

    CaseEnforcement.pluck(:case_number).each do |num|
      year = num.split("-")[1]

      next if !year
      next if (year.first != "HQ" || year.first.to_i.to_s != year.first)

      next if (year.length != 4 || year.to_i.to_s != year || !year.match(/^(\d)+$/) )
      puts year

      counter[year] += 1
    end

    p counter
  end

  task group_by_lead: :environment do
    counter = Hash.new(0)

    CaseEnforcement.pluck(:lead).each do |lead|
      counter[lead] += 1
    end

    p counter
  end

  task violations: :environment do
    counter = 0
    activity_ids = CaseViolation.pluck(:activity_id).uniq
    tracker = Hash.new(0)

    activity_ids.each do |id|
      c = CaseEnforcement.find_by(activity_id: id)
      next if c.nil?
      next if c.violated_statutes.count != 1 && c.violation_types.count != 1

      counter += 1

      s = c.violated_statutes.first
      v = c.violation_types.first

      next if s.nil? || v.nil?

      str =
        s.statute_code + "%$~%yk" +
        s.law_section_code + "%$~%yk" +
        s.law_section_desc + "%$~%yk" +
        v.violation_type_code + "%$~%yk" +
        v.violation_type_desc

      tracker[str] += 1

      puts str
    end

    puts "#{counter} violation types matched with statute."
    p tracker
  end

  task violations_to_sheet: :environment do
    book = Spreadsheet::Workbook.new

    sheet1 = book.create_worksheet
    sheet1.name = 'top_violations'

    counter = 0
    sheet1.row(counter).concat(%w{statute_code law_section_code law_section_desc violation_type_code violation_type concat count})


    VIOLATIONS_HASH.each do |k, v|
      counter += 1

      split = k.split("%$~%yk")
      sheet1.update_row(
        counter,
        split[0],
        split[1],
        split[2],
        split[3],
        split[4],
        split.join(" "),
        v
      )
    end

    output_path = Rails.root.join('lib', 'tasks', 'enforcements', 'violations_count-v0.xls')
    book.write(output_path)
  end
end
