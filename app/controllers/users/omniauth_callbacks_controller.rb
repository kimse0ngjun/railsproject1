class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    #구글 소셜 로그인
  def google_oauth2
    @user = User.from_omniauth(request.env['omniauth.auth'])
    if @user.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
      sign_in_and_redirect @user, event: :authentication
    else
      session['devise.google_data'] = {
        provider: request.env['omniauth.auth'].provider,
        uid: request.env['omniauth.auth'].uid,
        email: request.env['omniauth.auth'].info.email,
		username: request.env['omniauth.auth'].info.name
      }
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end
end