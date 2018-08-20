class Api::V1::EnforcementsController < ApplicationController
  def show
    @facility = Facility.find(params[:id])
    render json: @facility
  end
end
