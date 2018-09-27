# == Schema Information
#
# Table name: case_statutes
#
#  id               :bigint(8)        not null, primary key
#  activity_id      :bigint(8)
#  case_number      :string
#  rank_order       :integer
#  statute_code     :string
#  law_section_code :string
#  law_section_desc :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class CaseStatute < ApplicationRecord

  belongs_to :case,
    class_name: 'CaseEnforcement',
    primary_key: :activity_id,
    foreign_key: :activity_id

    def self.group_by_violated_statutes
      counter = Hash.new(0)

      CaseStatute.find_each do |s|
        statute_identifier = "#{s.statute_code} #{s.law_section_code} - #{s.law_section_desc}"
        counter[statute_identifier] += 1
      end

      counter
    end
end
