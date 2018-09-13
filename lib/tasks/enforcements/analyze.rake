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
end
