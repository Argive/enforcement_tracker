# == Schema Information
#
# Table name: facilities
#
#  id                            :bigint(8)        not null, primary key
#  registry_id                   :bigint(8)        not null
#  fac_name                      :string
#  fac_street                    :string
#  fac_city                      :string
#  fac_state                     :string
#  fac_zip                       :integer
#  fac_epa_region                :integer
#  fac_lat                       :float
#  fac_long                      :float
#  fac_naics_codes               :string
#  fac_inspection_count          :integer
#  fac_date_last_inspection      :string
#  fac_informal_count            :integer
#  fac_date_last_informal_action :string
#  fac_formal_action_count       :integer
#  fac_date_last_formal_action   :string
#  fac_total_penalties           :integer
#  fac_penalty_count             :integer
#  fac_date_last_penalty         :string
#  fac_last_penalty_amount       :integer
#  caa_evaluation_count          :integer
#  caa_informal_count            :integer
#  caa_formal_action_count       :integer
#  caa_penalties                 :integer
#  cwa_inspection_count          :integer
#  cwa_informal_count            :integer
#  cwa_formal_action_count       :integer
#  cwa_penalties                 :integer
#  rcra_inspection_count         :integer
#  rcra_informal_count           :integer
#  rcra_formal_action_count      :integer
#  rcra_penalties                :integer
#  sdwa_informal_count           :integer
#  sdwa_formal_action_count      :integer
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#

require 'test_helper'

class FacilityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
