# == Schema Information
#
# Table name: statute_violation_matches
#
#  id                      :bigint(8)        not null, primary key
#  key                     :string           not null
#  statute_code            :string
#  law_section_code        :string
#  law_section_desc        :string
#  violation_type_code     :string
#  violation_type          :string
#  count                   :integer
#  top_level_epa_summary   :string
#  top_level_usc           :string
#  drilldown_epa_summary   :string
#  drilldown_usc           :string
#  drilldown_cfr           :string
#  drilldown_fr            :string
#  other_links             :string           is an Array
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  average_penalty         :float
#  violations_with_no_fine :integer
#  percentage_with_fine    :float
#  summary                 :text
#

class StatuteViolationMatch < ApplicationRecord

  has_many :comments,
    class_name: 'Comment',
    primary_key: :id,
    foreign_key: :violation_id

  default_scope { order('id') }

  extend Rack::Reducer
  reduces self.all, filters: [
    ->(statute_code:) { where(statute_code: statute_code) },
    ->(other:)  {
                  where.not(statute_code: 'CAA')
                  .where.not(statute_code: 'CWA')
                  .where.not(statute_code: 'RCRA')
                }
  ]

end
