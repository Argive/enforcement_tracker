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
#

require 'test_helper'

class StatuteViolationMatchTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
