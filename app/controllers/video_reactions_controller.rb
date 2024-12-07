class VideoReactionsController < ApplicationController
  before_action :set_video

  # 좋아요 처리
  def like
    @reaction = @video.video_reactions.find_or_initialize_by(user: current_user)

    if @reaction.new_record?
      @reaction.reaction_type = 1  # 좋아요
      @reaction.save
      @video.increment!(:likes)  # 좋아요 수 증가
    else
      # 이미 좋아요인 경우 취소
      @reaction.destroy
      @video.decrement!(:likes)  # 좋아요 수 감소
    end

    redirect_to @video  # 리다이렉트
  end

  # 싫어요 처리
  def dislike
    @reaction = @video.video_reactions.find_or_initialize_by(user: current_user)

    if @reaction.new_record?
      @reaction.reaction_type = 0  # 싫어요
      @reaction.save
      @video.increment!(:dislike)  # 싫어요 수 증가
    else
      # 이미 싫어요인 경우 취소
      @reaction.destroy
      @video.decrement!(:dislike)  # 싫어요 수 감소
    end

    redirect_to @video  # 리다이렉트
  end

  private

  def set_video
    @video = Video.find_by(id: params[:id])
    unless @video
      redirect_to videos_path, alert: "영상이 존재하지 않습니다."
    end
  end
end
