require_relative './files/gov_keywords'

namespace :categorize_by_name do
  task gov: :environment do
    Facility.where(fac_naics_codes: nil).offset(1000).limit(1000).pluck(:id, :fac_name).each do |id_name|
      id_name[1].split(" ").each do |word|
        if GOV_SINGLE_WORDS.include?(word)
          puts id_name[1]
          break
        end
      end
    end
  end
end
