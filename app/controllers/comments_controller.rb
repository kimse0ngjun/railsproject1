class CommentsController < ApplicationController
  def create
    @video = Video.find(params[:video_id]) # 부모 비디오 찾기
    @comment = @video.comments.build(comment_params) # 댓글 생성
    @comment.user = current_user # 현재 사용자 연결

    if @comment.save
      redirect_to video_path(@video), notice: '댓글이 추가되었습니다.'
    else
      redirect_to video_path(@video), alert: '댓글 작성에 실패했습니다.'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
