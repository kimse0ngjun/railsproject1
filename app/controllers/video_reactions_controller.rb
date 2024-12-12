class VideoReactionsController < ApplicationController
  before_action :set_video

  # 좋아요 처리
  def like
    @reaction = @video.video_reactions.find_or_initialize_by(user: current_user)

    if @reaction.new_record?
      @reaction.reaction_type = 1  # 좋아요
      @reaction.save
      @video.increment!(:likes)  # 좋아요 수 증가

      # 만약 싫어요가 이미 눌러져 있다면 취소
      existing_dislike = @video.video_reactions.find_by(user: current_user, reaction_type: 0)
      if existing_dislike
        existing_dislike.destroy
        @video.decrement!(:dislike)  # 싫어요 수 감소
      end
    else
      # 이미 좋아요인 경우 취소
      @reaction.destroy
      @video.decrement!(:likes)  # 좋아요 수 감소
    end

    respond_to do |format|
      format.js { render 'videos_reactions/like' }
    end
  end

  # 싫어요 처리
  def dislike
    @reaction = @video.video_reactions.find_or_initialize_by(user: current_user)

    if @reaction.new_record?
      @reaction.reaction_type = 0  # 싫어요
      @reaction.save
      @video.increment!(:dislike)  # 싫어요 수 증가

      # 만약 좋아요가 이미 눌러져 있다면 취소
      existing_like = @video.video_reactions.find_by(user: current_user, reaction_type: 1)
      if existing_like
        existing_like.destroy
        @video.decrement!(:likes)  # 좋아요 수 감소
      end
    else
      # 이미 싫어요인 경우 취소
      @reaction.destroy
      @video.decrement!(:dislike)  # 싫어요 수 감소
    end

    respond_to do |format|
      format.js { render 'videos_reactions/dislike' }
    end
  end

  private

  def set_video
    @video = Video.find_by(id: params[:id])  # 비디오 찾기
    unless @video
      redirect_to videos_path, alert: "영상이 존재하지 않습니다."
    end
  end
end
