# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    auth = request.env["omniauth.auth"]
    @user = User.from_omniauth(auth)
    
    if @user.persisted?
      # 이미 가입된 사용자는 바로 로그인
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
    else
      # 신규 사용자의 경우, Omniauth 데이터를 세션에 저장한 후 SNS 회원가입 페이지로 이동
      session["devise.google_data"] = auth.except("extra")
      redirect_to sns_sign_up_path
    end
  end

  def failure
    redirect_to root_path
  end
end
