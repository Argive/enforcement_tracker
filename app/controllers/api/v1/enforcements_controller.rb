class Api::V1::EnforcementsController < ApplicationController

  def summarize
    @enforcement_informal_count = Facility.sum(:fac_informal_count) # <5 years
    @enforcement_formal_count = Facility.sum(:fac_formal_action_count)
    @enforcement_total_penalties_dollar = Facility.sum(:fac_total_penalties).to_i

    @enforcement_caa_informal_count = Facility.sum(:caa_informal_count)
    @enforcement_caa_formal_count = Facility.sum(:caa_formal_action_count)
    @enforcement_caa_penalties_dollar = Facility.sum(:caa_penalties).to_i

    @enforcement_cwa_informal_count = Facility.sum(:cwa_informal_count)
    @enforcement_cwa_formal_count = Facility.sum(:cwa_formal_action_count)
    @enforcement_cwa_penalties_dollar = Facility.sum(:cwa_penalties).to_i

    @enforcement_rcra_informal_count = Facility.sum(:rcra_informal_count)
    @enforcement_rcra_formal_count = Facility.sum(:rcra_formal_action_count)
    @enforcement_rcra_penalties_dollar = Facility.sum(:rcra_penalties).to_i

    @enforcement_sdwa_informal_count = Facility.sum(:sdwa_informal_count)
    @enforcement_sdwa_formal_count = Facility.sum(:sdwa_formal_action_count)

    render json: {
      enforcement_informal_count_5_yr: @enforcement_informal_count,
      enforcement_formal_count: @enforcement_formal_count,
      enforcement_total_penalties_dollar: @enforcement_total_penalties_dollar,
      enforcement_caa_informal_count: @enforcement_caa_informal_count,
      enforcement_caa_formal_count: @enforcement_caa_formal_count,
      enforcement_caa_penalties_dollar: @enforcement_caa_penalties_dollar,
      enforcement_cwa_informal_count: @enforcement_cwa_informal_count,
      enforcement_cwa_formal_count: @enforcement_cwa_formal_count,
      enforcement_cwa_penalties_dollar: @enforcement_cwa_penalties_dollar,
      enforcement_rcra_informal_count: @enforcement_rcra_informal_count,
      enforcement_rcra_formal_count: @enforcement_rcra_formal_count,
      enforcement_rcra_penalties_dollar: @enforcement_rcra_penalties_dollar,
      enforcement_sdwa_informal_count: @enforcement_sdwa_informal_count,
      enforcement_sdwa_formal_count: @enforcement_sdwa_formal_count
    }
  end
end
