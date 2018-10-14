# == Schema Information
#
# Table name: facility_programs
#
#  id              :bigint(8)        not null, primary key
#  registry_id     :bigint(8)
#  program_acronym :string
#  program_id      :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class FacilityProgramTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
