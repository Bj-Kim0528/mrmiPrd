class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?




  def new
    super
    @minimum_password_length = Devise.password_length.first
  end


  protected

  # 회원가입 후, 사용자가 아직 확인되지 않았으므로
  # after_inactive_sign_up_path_for를 재정의하여 인증번호 입력 페이지로 리다이렉트합니다.
  def after_inactive_sign_up_path_for(resource)
    new_user_confirmation_path  # 아래에서 설정할 이메일 인증번호 입력 페이지의 라우트
  end

  def configure_permitted_parameters
    # 회원가입 시 email_local, email_domain, nickname, terms_of_service, privacy_policy 허용
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email_local, :email_domain, :nickname, :terms_of_service, :privacy_policy])
    
    # 계정 업데이트 시에도 허용
    devise_parameter_sanitizer.permit(:account_update, keys: [:email_local, :email_domain, :nickname, :terms_of_service, :privacy_policy])
  end
  
end

