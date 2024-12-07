class User < ApplicationRecord
  has_many :comments, dependent: :destroy
  # Devise 인증 관련 설정
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Omniauth를 통한 사용자 생성/업데이트
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.uid = auth.uid
      user.email = auth.info.email || "#{auth.uid}@#{auth.provider}.com"  # 이메일 대체 생성
      user.password = Devise.friendly_token[0, 20]
      user.username = auth.info.name || "Anonymous User"  # 이름 기본값
      Rails.logger.info "Provider: #{auth.provider}, UID: #{auth.uid}, Email: #{user.email}"
    end
  end

  # JWT 토큰 생성
  def generate_jwt
    payload = { user_id: self.id }
    JWT.encode(payload, Rails.application.credentials.secret_key_base, 'HS256')
  end

  # JWT 토큰을 통해 사용자 인증
  def self.authenticate_with_jwt(token)
    begin
      decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: 'HS256')
      user_id = decoded_token[0]['user_id']
      User.find(user_id)
    rescue JWT::DecodeError
      nil
    end
  end

  # 좋아요 및 싫어요 관계 설정
  has_many :video_reactions, dependent: :destroy
  has_many :liked_videos, -> { where video_reactions: { reaction_type: 1 } }, through: :video_reactions, source: :video
  has_many :disliked_videos, -> { where video_reactions: { reaction_type: 0 } }, through: :video_reactions, source: :video
end
