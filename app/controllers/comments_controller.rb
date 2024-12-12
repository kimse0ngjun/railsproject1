class CommentsController < ApplicationController
  before_action :set_comment, only: [:like, :dislike, :destroy] 
  before_action :set_video, only: [:create, :like, :dislike]

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

  # 좋아요 액션
  def like
    @comment.like!
    redirect_to video_path(@video), notice: '좋아요 상태가 변경되었습니다.'
  end

  # 싫어요 액션
  def dislike
    @comment.dislike!
    redirect_to video_path(@video), notice: '싫어요 상태가 변경되었습니다.'
  end

  # 댓글 삭제
  def destroy
    @comment = Comment.find(params[:id])
    @video = @comment.video

    if @comment.destroy_with_reactions
      respond_to do |format|
        format.js   # JavaScript 응답
        format.html { redirect_to video_path(@video), notice: '댓글이 삭제되었습니다.' }
      end
    else
      render json: { success: false, message: '댓글 삭제에 실패했습니다.' }, status: :unprocessable_entity
    end
  end

  # 대댓글 삭제
  def destroy_reply
    @comment = Comment.find(params[:id])
    @comment.destroy

    render json: { success: true, message: '대댓글이 삭제되었습니다.', reply_id: @reply.id }
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :parent_id)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_video
    @video = Video.find(params[:video_id])
  end
end
