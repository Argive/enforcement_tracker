class Api::V1::CommentsController < ApplicationController
  def group_by_violation
    v = StatuteViolationMatch.find(params[:violation_id])
    render json: v.comments
  end

  def index
    c = Comment.all
    render json: c
  end
end
