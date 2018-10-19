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

  def associated_actions
    facility = Facility.find_by(registry_id: params[:registry_id])
    actions = facility.associated_actions

    render json: actions
  end

  def applicable_statutes
    facility = Facility.find_by(registry_id: params[:registry_id])
    statutes = facility.applicable_statutes

    render json: statutes

  end
end
