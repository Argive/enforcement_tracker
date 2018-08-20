class Api::V1::InspectionsController < ApplicationController
  def show
    @facility = Facility.find(params[:id])
    render json: @facility
  end
end
