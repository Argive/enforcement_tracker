class Api::V1::InspectionsController < ApplicationController

  def summarize
    @inspection_count = Facility.sum(:fac_inspection_count) # from past 5 years only
    facilities_inspected = Facility.where('fac_inspection_count > ?', 0)
    @facilities_inspected_count = facilities_inspected.count
    @small_business_inspected_count = facilities_inspected.where(fac_type: 'small').count

    render json: {
      inspection_count_5_yr: @inspection_count,
      facilities_inspected_count: @facilities_inspected_count,
      small_business_inspected_count: @small_business_inspected_count
    }
  end

  def tally_by_state
    @inspections_by_state = Facility.tally_inspections_by_state

    render json: @inspections_by_state
  end

end
