# == Schema Information
#
# Table name: case_statutes
#
#  id               :bigint(8)        not null, primary key
#  activity_id      :integer
#  case_number      :string
#  rank_order       :integer
#  statute_code     :string
#  law_section_code :string
#  law_section_desc :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class CaseStatuteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
