class Api::V1::CommentsController < ApplicationController

  def group_by_violation
    v = StatuteViolationMatch.find(params[:violation_id])
    render json: v.comments
  end

  def index
    c = Comment.all
    render json: c
  end

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      render json: @comment
    else
      render json: @comment.errors.full_messages, status: 422
    end
  end

  private

  def comment_params
    params.require(:comment).permit(
      :violation_id, :commenter_name, :body
    )
  end
end
