class Video < ApplicationRecord
  attr_accessor :skip_update_reaction_counts

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
  after_save :update_reaction_counts, unless: :skip_update_reaction_counts

  # 동영상 조회수 증가
  def increment_views!
    self.increment!(:views)
  end

  # 동영상 업로드 후 썸네일 생성
  after_create :generate_thumbnail

  # 썸네일 생성 메서드
  def generate_thumbnail
    return unless uploaded_video.attached? || video_url.present?

    begin
      if video_url.include?("youtube.com")
        video_id = youtube_video_id(video_url)
        thumbnail_url = fetch_youtube_thumbnail(video_id)
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
    # 좋아요/싫어요 카운트가 변경되었을 경우에만 save를 호출
    new_likes_count = video_reactions.where(reaction_type: 1).count
    new_dislikes_count = video_reactions.where(reaction_type: 0).count

    if self.likes_count != new_likes_count || self.dislikes_count != new_dislikes_count
      self.likes_count = new_likes_count
      self.dislikes_count = new_dislikes_count
      self.skip_update_reaction_counts = true  # 무한 루프 방지
      save
    end
  end

  # YouTube 비디오 ID 추출
  def youtube_video_id(url)
    match = url.match(/(?:https?:\/\/)?(?:www\.)?(?:youtube|youtu|youtube-nocookie)\.(?:com\/(?:[^\/]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})/)
    match ? match[1] : nil
  end

  # YouTube Data API를 사용해 비디오 썸네일을 가져오는 메서드
  def fetch_youtube_thumbnail(video_id)
    api_key = ENV['AIzaSyC0lhBN_7Bh37SnCwjREK5trFe4slO08Us']
    url = "https://www.googleapis.com/youtube/v3/videos?id=#{video_id}&key=#{api_key}&part=snippet"
    uri = URI.parse(url)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)

    if data["items"].any?
      thumbnail_url = data["items"].first["snippet"]["thumbnails"]["high"]["url"]
      return thumbnail_url
    else
      raise "비디오 정보를 가져오는 데 실패했습니다."
    end
  end

  # 썸네일을 다운로드하여 ActiveStorage에 첨부
  def download_thumbnail(thumbnail_url)
    image = URI.open(thumbnail_url)
    thumbnail_image.attach(io: image, filename: 'thumbnail.jpg', content_type: 'image/jpg')
  rescue => e
    Rails.logger.error "썸네일 다운로드 실패: #{e.message}"
  end
end
