class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: [:like, :dislike, :destroy]
  before_action :set_video, only: [:create, :like, :dislike]

  # def show
  # end
  # 댓글 및 대댓글 생성
  def create
    @comment = @video.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to video_path(@video), notice: @comment.parent_id.present? ? '대댓글이 추가되었습니다.' : '댓글이 추가되었습니다.'
    else
      redirect_to video_path(@video), alert: '댓글 작성에 실패했습니다.'
    end
  end

  def like
    # 댓글에 좋아요 추가 또는 취소
	@comment = Comment.find(params[:id])
    @comment.like!
    redirect_to video_path(@comment.video)
  end

  def dislike
    # 댓글에 싫어요 추가 또는 취소
	@comment = Comment.find(params[:id])
    @comment.dislike!
    redirect_to video_path(@comment.video)
  end

   def destroy
	@comment = Comment.find(params[:id])

	  # 댓글 및 반응을 삭제하는 메서드 호출
	if @comment.destroy_with_reactions
		respond_to do |format|
		  format.js { render 'destroy' }  # JavaScript 응답 (댓글을 삭제한 후 화면에서 제거)
		  format.html { redirect_to video_path(@comment.video), notice: "댓글이 성공적으로 삭제되었습니다." }
		end
	  else
		redirect_to video_path(@comment.video), alert: "댓글 삭제에 실패했습니다."
	  end
	end


  private

  def set_comment
    @comment = Comment.find_by(id: params[:id], video_id: params[:video_id])
    redirect_to video_path, alert: "댓글을 찾을 수 없습니다." unless @comment
  end
	
  def comment_params
    params.require(:comment).permit(:content, :parent_id)
  end

  def set_video
    @video = Video.find(params[:video_id])
  end
end
