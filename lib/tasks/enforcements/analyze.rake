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
end
