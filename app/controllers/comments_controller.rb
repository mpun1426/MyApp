class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.new(comment_params)
    if @comment.save
      flash[:notice] = "コメントを投稿しました"
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = "コメントが未入力のため投稿できませんでした"
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :spot_id)
  end
end
