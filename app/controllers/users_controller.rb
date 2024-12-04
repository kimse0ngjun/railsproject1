class UsersController < ApplicationController
  # 회원가입 폼을 렌더링
  def new
    @user = User.new
  end

  # 회원가입 처리
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: '회원가입이 완료되었습니다.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  # 사용자 매개변수 설정 (예: email, password 등)
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
