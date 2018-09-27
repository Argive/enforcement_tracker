class Api::V1::FacilitiesController < ApplicationController

  def index
    @facilities = Facility.reduce(params).page(params[:page]).per(100)
    render json: @facilities
  end

  def index_geo
    @facilities = Facility.reduce(params).page(params[:page]).per(1000)
    render :json => @facilities.as_json(:only => [:id, :fac_lat, :fac_long, :fac_type])
  end

  def show
    @facility = Facility.find(params[:id])
    render json: @facility
  end

  def summarize
    facility_summary = Facility.summarize
    render json: facility_summary
  end

  def industry_count
    industries = Facility.count_industries
    render json: industries
  end
end
