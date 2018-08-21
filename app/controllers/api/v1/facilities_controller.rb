class Api::V1::FacilitiesController < ApplicationController
  def index
    @facilities = Facility.reduce(params).page(params[:page]).per(100)
    render json: @facilities
  end

  def show
    @facility = Facility.find(params[:id])
    render json: @facility
  end

  def summarize
    @facility_count = Facility.count
    render json: {
      facility_count: @facility_count
    }
  end
end
