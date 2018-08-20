class Api::V1::FacilitiesController < ApplicationController
  def show
    @facility = Facility.find(params[:id])
    render json: @facility
  end
end
