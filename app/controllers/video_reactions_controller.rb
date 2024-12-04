class VideoReactionsController < ApplicationController
  before_action :set_video

  # 좋아요
  def like
    reaction = @video.video_reactions.find_or_initialize_by(user: current_user)

    if reaction.reaction_type == 1  # 이미 좋아요라면 취소
      reaction.destroy
    else
      reaction.update(reaction_type: 1)  # 좋아요
      @video.video_reactions.find_by(user: current_user, reaction_type: 0)&.destroy  # 기존 싫어요 취소
    end

    # 좋아요, 싫어요 수를 업데이트한 후 JS로 응답
    respond_to do |format|
      format.js { render 'videos/update_like_dislike_counts' }  # 좋아요/싫어요 수를 업데이트하는 JS 파일 렌더링
    end
  end

  # 싫어요
  def dislike
    reaction = @video.video_reactions.find_or_initialize_by(user: current_user)

    if reaction.reaction_type == 0  # 이미 싫어요라면 취소
      reaction.destroy
    else
      reaction.update(reaction_type: 0)  # 싫어요
      @video.video_reactions.find_by(user: current_user, reaction_type: 1)&.destroy  # 기존 좋아요 취소
    end

    # 좋아요, 싫어요 수를 업데이트한 후 JS로 응답
    respond_to do |format|
      format.js { render 'videos/update_like_dislike_counts' }  # 좋아요/싫어요 수를 업데이트하는 JS 파일 렌더링
    end
  end

  private

  # 비디오를 설정하는 메서드
  def set_video
    @video = Video.find_by(id: params[:id])
    unless @video
      redirect_to videos_path, alert: "영상이 존재하지 않습니다."
    end
  end

  # 응답 형식을 처리하는 메서드
  def respond_to_format
    respond_to do |format|
      format.js { render 'videos/like_dislike' }  # 프론트엔드에 반영될 파일 렌더링
    end
  end
end
