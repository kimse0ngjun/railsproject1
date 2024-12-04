class SessionsController < ApplicationController
  def new
    # 로그인 폼을 보여주는 액션
  end

  def create
    # 로그인 로직 (예: 이메일, 비밀번호 확인)
    if user_authenticated?
      redirect_to dashboard_path  # 로그인 성공 후 대시보드 페이지로 리디렉션
    else
      flash[:alert] = "로그인 실패"
      render :new  # 로그인 실패 시 다시 로그인 폼을 렌더링
    end
  end

  private

  def user_authenticated?
    # 사용자 인증 로직 구현
  end
end
