namespace :misc do
  task count_words: :environment do
    counter = Hash.new(0)

    Facility.where(fac_type: 'gov').pluck(:fac_name).each do |name|
      words = name.split(" ")
      words.each { |word| counter[word] += 1 }
    end

    puts counter.sort_by { |k, v| -v }[0..200].map { |pair| "'#{pair.first}'," }
  end

  task count_2_words: :environment do
    counter = Hash.new(0)

    Facility.where(fac_type: 'gov').pluck(:fac_name).each do |name|
      words = name.split(" ").each_cons(2).map { |word| word.join(" ") }
      words.each { |word| counter[word] += 1 }
    end

    puts counter.sort_by { |k, v| -v }[0..200].map { |pair| "'#{pair.first}'," }
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
