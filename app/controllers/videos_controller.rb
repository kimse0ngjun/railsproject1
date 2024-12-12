class VideosController < ApplicationController
  before_action :set_video, only: [:show, :edit, :update, :destroy, :like, :dislike]
  skip_before_action :authenticate_user!, only: [:search, :index, :new, :show] 

  # 영상 목록
  def index
    @videos = Video.all.order(created_at: :desc) # 최신 순 정렬
  end

  # 영상 상세보기
  def show
   @video = Video.find(params[:id])
   @new_comment = Comment.new  # 댓글을 위한 새로운 객체 생성
   @comments = @video.comments # 댓글 로드

  respond_to do |format|
    format.html # 기본적으로 HTML 응답을 반환
    format.json { render json: @video } # JSON 응답을 반환할 경우
  end
end

  
  # 새로운 조회수 증가 액션 추가
  def increment_views
    @video = Video.find(params[:id])
    @video.increment_views!
    render json: { views: @video.views }
  end

  # 영상 업로드 폼
  def new
    @video = Video.new
  end

  # 영상 업로드
  def create
    @video = Video.new(video_params)
    if @video.save
      if @video.uploaded_video.attached?
        Rails.logger.info "파일이 성공적으로 업로드되었습니다."
      else
        Rails.logger.error "파일 업로드에 실패했습니다."
      end
      redirect_to @video, notice: "영상이 성공적으로 업로드 되었습니다."
    else
      render :new
    end
  end

  # 영상 수정 폼
  def edit
  end

  # 영상 수정
  def update
    if @video.update(video_params)
      redirect_to @video, notice: "영상이 성공적으로 업데이트 되었습니다."
    else
      render :edit
    end
  end

  # 영상 삭제
  def destroy
    @video.destroy
    redirect_to videos_url, notice: "영상이 성공적으로 삭제되었습니다."
  end

  # 검색 기능
  def search
    if params[:query].present?
      # 검색어와 일치하는 영상 목록
      @videos = Video.where("title LIKE ?", "%#{params[:query]}%")
    else
      @videos = [] # 검색어가 없을 때 빈 배열
    end
	 

    # 검색 결과가 없을 경우 추천 영상 가져오기
    @recommended_videos = Video.order(created_at: :desc).limit(5) if @videos.empty?

    # 명시적으로 search.html.erb를 렌더링
    render 'search'
  end

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
      format.html { redirect_to @video }  # HTML 요청일 경우 리다이렉트
      format.js   # JavaScript 요청일 경우 like.js.erb 템플릿을 렌더링
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
      format.html { redirect_to @video }  # HTML 요청일 경우 리다이렉트
      format.js   # JavaScript 요청일 경우 dislike.js.erb 템플릿을 렌더링
    end
  end

  private

  # set_video 메소드 정의
  def set_video
    @video = Video.find_by(id: params[:id])
    unless @video
      redirect_to videos_path, alert: "영상이 존재하지 않습니다."
    end
  end

  # video_params 메소드 정의
  def video_params
    params.require(:video).permit(:title, :description, :subscription, :video_url, :likes, :dislike, :video_length, :uploaded_video, :thumbnail_image)
  end
end
