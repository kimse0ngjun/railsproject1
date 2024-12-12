class Video < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :viewing_histories, dependent: :destroy
  has_many :video_reactions, dependent: :destroy

  has_many :liked_users, -> { where video_reactions: { reaction_type: 1 } }, through: :video_reactions, source: :user
  has_many :disliked_users, -> { where video_reactions: { reaction_type: 0 } }, through: :video_reactions, source: :user

  has_one_attached :uploaded_video
  has_one_attached :thumbnail_image

  validates :title, presence: true
  validates :video_url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "유효한 URL을 입력해주세요." }

  # description 기본값 설정
  before_save :set_default_description
  before_save :set_youtube_video_url

  # 좋아요 수를 계산하는 메서드
  def likes
    video_reactions.where(reaction_type: 1).count
  end

  # 싫어요 수를 계산하는 메서드
  def dislikes
    video_reactions.where(reaction_type: 0).count
  end

  # 좋아요/싫어요 카운트 업데이트
  after_save :update_reaction_counts

  # 동영상 조회수 증가
  def increment_views!
    update(views: views + 1)
  end
	
  # 댓글 수 계산 (대댓글 제외)
  def comments_count
    comments.where(parent_id: nil).count
  end

  # 전체 댓글 수 계산 (대댓글 포함)
  def total_comments_count
    comments.count
  end
	
  # 동영상 업로드 후 썸네일 생성
  after_create :generate_thumbnail

  # 썸네일 생성 메서드
  def generate_thumbnail
  return unless uploaded_video.attached? || video_url.present?

  begin
    if video_url.include?("youtube.com")
      video_id = extract_youtube_video_id(video_url)
      thumbnail_url = "https://img.youtube.com/vi/#{video_id}/maxresdefault.jpg"
      download_thumbnail(thumbnail_url)
      self.youtube_thumbnail_url = thumbnail_url  # youtube_thumbnail_url에 썸네일 URL 저장
    else
      generate_local_thumbnail
    end
  rescue => e
    Rails.logger.error "Thumbnail generation failed: #{e.message}"
  end
end


  private

  # description이 비어있으면 기본값 설정
  def set_default_description
    self.description ||= "설명이 없습니다."
  end

  # youtube_url 설정
  def set_youtube_video_url
    if self.video_url.present? && self.video_url.include?("youtube.com")
      self.youtube_video_url = video_url
    end
  end

  # 좋아요/싫어요 카운트 업데이트 메서드
  def update_reaction_counts
  self.likes_count = video_reactions.where(reaction_type: 1).count
  self.dislikes_count = video_reactions.where(reaction_type: 0).count
  update_columns(likes_count: likes_count, dislikes_count: dislikes_count)
  end


  # YouTube 비디오 ID 추출
  def extract_youtube_video_id(url)
    url.match(/(?:https?:\/\/)?(?:www\.)?(?:youtube|youtu|youtube-nocookie)\.(?:com\/(?:[^\/]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})/)[1]
  end

  # 썸네일을 다운로드하여 ActiveStorage에 첨부
  def download_thumbnail(thumbnail_url)
    image = URI.open(thumbnail_url)
    thumbnail_image.attach(io: image, filename: 'thumbnail.jpg', content_type: 'image/jpg')
  end

  # 로컬 비디오 파일에서 썸네일을 생성
  def generate_local_thumbnail
    video_path = Rails.root.join("tmp", "uploads", uploaded_video.filename.to_s)
    File.open(video_path, 'wb') do |file|
      file.write(uploaded_video.download)
    end

    thumbnail_path = Rails.root.join("tmp", "thumbnail.jpg")
    system("ffmpeg -i #{video_path} -ss 00:00:01 -vframes 1 #{thumbnail_path}")

    thumbnail_image.attach(io: File.open(thumbnail_path), filename: 'thumbnail.jpg', content_type: 'image/jpeg')

    File.delete(video_path)
    File.delete(thumbnail_path)
  end
end
