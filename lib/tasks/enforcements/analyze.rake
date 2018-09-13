namespace :analyze do
  task statute_frequency: :environment do
    counter = Hash.new(0)

    CaseStatute.all.each do |c|
      counter[c.law_section_desc] += 1
      puts c.law_section_desc
    end

    p counter.sort_by { |k, v| -v }[0..50]
  end
end
