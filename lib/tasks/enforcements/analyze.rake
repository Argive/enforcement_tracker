require 'csv'
require 'spreadsheet'
require_relative 'terminal_output'
require 'descriptive_statistics'

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

  task enforced_facilities_check: :environment do
    counter = 0
    cwa_correct = 0
    caa_correct = 0
    rcra_correct = 0
    other_counter = 0

    cwa_false_negative = 0
    caa_false_negative = 0
    rcra_false_negative = 0

    Facility.find_each do |f|
      violated_statutes = f.violated_statutes.distinct.pluck(:statute_code)

      violated_statutes.each do |s|
        case s
        when "CAA"
          if !f.caa_applicable
            f.caa_applicable = true
            caa_false_negative += 1
          else
            caa_correct += 1
          end
        when "CWA"
          if !f.cwa_applicable
            f.cwa_applicable = true
            cwa_false_negative += 1
          else
            cwa_correct += 1
          end
        when "RCRA"
          if !f.rcra_applicable
            f.rcra_applicable = true
            rcra_false_negative += 1
          else
            rcra_correct += 1
          end
        else
          other_counter += 1
        end
        f.save
      end
      counter += 1
      puts counter
    end

    puts "#{counter} facilities analyzed. "
    puts "Correctly identified statutes (CAA, CWA, RCRA): #{caa_correct}, #{cwa_correct}, #{rcra_correct}."
    puts "Mismatches (CAA, CWA, RCRA): #{caa_false_negative}, #{cwa_false_negative}, #{rcra_false_negative}."
    puts "other counter: #{other_counter}"
  end

  task penalty_distribution: :environment do
    data = CaseEnforcement.where('total_penalty_assessed_amt > ?', 0)
                          .pluck(:total_penalty_assessed_amt).compact

    p data.descriptive_statistics
  end

  task violations_avg_penalty: :environment do
    counter = 0
    activity_ids = CaseViolation.pluck(:activity_id).uniq
    tracker = {}

    activity_ids.each do |id|
      c = CaseEnforcement.find_by(activity_id: id)
      next if c.nil?
      next if c.violated_statutes.count != 1 && c.violation_types.count != 1

      counter += 1

      s = c.violated_statutes.first
      v = c.violation_types.first

      next if s.nil? || v.nil?

      str =
        s.statute_code + "-" +
        s.law_section_code + "-" +
        v.violation_type_code

      if tracker[str]
        tracker[str].push(c.total_penalty_assessed_amt)
      else
        tracker[str] = [c.total_penalty_assessed_amt]
      end

      puts counter
    end

    puts "#{counter} violation types matched with statute."
    p tracker

    averaged = {}

    tracker.each do |k, arr|
      averaged[k] = [arr.count(nil)]

      compacted = arr.compact
      averaged[k].push(compacted.inject{ |sum, el| sum + el }.to_f / compacted.size)
    end

    p averaged
  end

  task enforced_facilities_check_optimized: :environment do
    counter = 0
    cwa_correct = 0
    caa_correct = 0
    rcra_correct = 0
    other_counter = 0

    cwa_false_negative = 0
    caa_false_negative = 0
    rcra_false_negative = 0

    CaseStatute.find_each do |st|
      s = st.statute_code
      next if st.case.nil?
      next if s.nil?
      registry_id = st.case.registry_id
      f = Facility.find_by(registry_id: registry_id)
      next if f.nil?

      case s
      when "CAA"
        if !f.caa_applicable
          f.caa_applicable = true
          caa_false_negative += 1
        else
          caa_correct += 1
        end
      when "CWA"
        if !f.cwa_applicable
          f.cwa_applicable = true
          cwa_false_negative += 1
        else
          cwa_correct += 1
        end
      when "RCRA"
        if !f.rcra_applicable
          f.rcra_applicable = true
          rcra_false_negative += 1
        else
          rcra_correct += 1
        end
      else
        other_counter += 1
      end
      f.save
      counter += 1
      puts counter
    end

    puts "#{counter} facilities analyzed. "
    puts "Correctly identified statutes (CAA, CWA, RCRA): #{caa_correct}, #{cwa_correct}, #{rcra_correct}."
    puts "Mismatches (CAA, CWA, RCRA): #{caa_false_negative}, #{cwa_false_negative}, #{rcra_false_negative}."
    puts "other counter: #{other_counter}"
  end

  task add_avg_penalty_to_violations: :environment do
    counter = 0

    VIOLATIONS_PENALTIES_HASH.each do |k, v|
      violation = StatuteViolationMatch.find_by(key: k)
      next if violation.nil?

      violation.violations_with_no_fine = v.first

      if v.last == NaN
        p 'NaN detected'
        violation.average_penalty = nil
      else
        violation.average_penalty = v.last
      end

      violation.save
      counter += 1
    end

    puts "#{counter} violations analyzed."
  end

  task inspected_facilities_check: :environment do
    counter = 0

    Facility.find_each do |f|
      caa_var = (f.caa_evaluation_count || 0 ) +
                (f.caa_informal_count || 0 ) +
                (f.caa_formal_action_count || 0 ) +
                (f.caa_penalties || 0 )

      cwa_var = (f.cwa_inspection_count || 0 ) +
                (f.cwa_informal_count || 0 ) +
                (f.cwa_formal_action_count || 0 ) +
                (f.cwa_penalties || 0 )

      rcra_var = (f.rcra_inspection_count || 0 ) +
                (f.rcra_informal_count || 0 ) +
                (f.rcra_formal_action_count || 0 ) +
                (f.rcra_penalties || 0 )

      sdwa_var = (f.sdwa_formal_action_count || 0 ) +
                (f.sdwa_informal_count || 0 )

      f.caa_applicable = true if caa_var > 0
      f.cwa_applicable = true if cwa_var > 0
      f.rcra_applicable = true if rcra_var > 0
      f.sdwa_applicable = true if sdwa_var > 0

      f.save
      counter += 1
    end

    puts "#{counter} facilities analyzed"
  end
end
