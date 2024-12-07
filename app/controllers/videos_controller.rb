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
	# 조회수 증가
  	@video.increment_views!
	# 댓글 목록 불러오기
	@comments = @video.comments.includes(:user)
	# 새 댓글 객체 생성
	@new_comment = Comment.new
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
