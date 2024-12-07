class ApplicationController < ActionController::Base
<<<<<<< Updated upstream
=======
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!, except: [:home] # 홈 액션 제외
>>>>>>> Stashed changes
end
