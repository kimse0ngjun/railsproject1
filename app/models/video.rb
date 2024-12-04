class Video < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :viewing_histories, dependent: :destroy
  has_many :video_reactions, dependent: :destroy

  has_many :liked_users, -> { where video_reactions: { reaction_type: 1 } }, through: :video_reactions, source: :user
  has_many :disliked_users, -> { where video_reactions: { reaction_type: 0 } }, through: :video_reactions, source: :user

  has_one_attached :uploaded_video
  has_one_attached :thumbnail_image

  validates :title, presence: true
  validates :video_url, presence: true

  # description 기본값 설정
  before_save :set_default_description

  # 좋아요 수
  def likes
    video_reactions.where(reaction_type: 1).count
  end

  # 싫어요 수
  def dislikes
    video_reactions.where(reaction_type: 0).count
  end
	
  def increment_views!
	  self.increment!(:views)
  end

  # 유튜브 영상 URL 설정
  before_save :set_youtube_video_url

  private

  # description이 비어있으면 기본값 설정
  def set_default_description
    self.description ||= "설명이 없습니다."
  end

  def set_youtube_video_url
    if self.video_url.present? && self.video_url.include?("youtube.com")
      self.youtube_video_url = video_url
    end
  end
end
