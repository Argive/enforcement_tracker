require 'http'
require 'json'
require 'net/http'
require 'set'

namespace :create_json do
  task facilities: :environment do
    temp_array = []
    already_visited = Set.new

    MAX_PAGES = 100
    rand_page = 1
    page_counter = 0

    loop do

      until !already_visited.include?(rand_page)
        rand_page = rand(1800)
      end

      url = "http://localhost:3000/api/v1/facilities/index_geo?page=#{rand_page}"
      uri = URI(url)

      response = Net::HTTP.get(uri)
      json_array = JSON.parse(response)

      break if json_array.empty? || page_counter == MAX_PAGES
      temp_array.concat(json_array)

      already_visited.add(rand_page)
      page_counter += 1
    end

    puts temp_array.length

    file = File.join(Rails.root.join("lib", "tasks", "files", "facilities_geo2.json"))

    File.open(file, 'w') do |f|
      f.write(JSON.dump(temp_array))
    end
  end

end
