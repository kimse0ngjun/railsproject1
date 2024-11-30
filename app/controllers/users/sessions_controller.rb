class Users::SessionsController < Devise::SessionsController
  def after_sign_out_path_for(_resource)
    new_user_session_path  # 로그아웃 후 리디렉션 경로
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path  # 로그인 후 리디렉션 경로
  end
end
