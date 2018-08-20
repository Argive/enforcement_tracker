class Api::V1::InspectionsController < ApplicationController

  def summarize
    @inspection_count = Facility.sum(:fac_inspection_count) # from past 5 years only
    render json: {
      inspection_count_5_yr: @inspection_count
    }
  end

end
