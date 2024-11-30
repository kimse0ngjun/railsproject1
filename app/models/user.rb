class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
		 :omniauthable, omniauth_providers: [:google_oauth2]
	
	def self.from_omniauth(auth)
  	where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    	user.uid = auth.uid
    	user.email = auth.info.email || "#{auth.uid}@#{auth.provider}.com"  # 이메일 대체 생성
    	user.password = Devise.friendly_token[0, 20]
    	user.username = auth.info.name || "Anonymous User"  # 이름 기본값
    	Rails.logger.info "Provider: #{auth.provider}, UID: #{auth.uid}, Email: #{user.email}"
  	end
  end
end
