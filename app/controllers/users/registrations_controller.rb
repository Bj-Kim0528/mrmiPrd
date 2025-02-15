class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    # 회원가입 시 email_local, email_domain, nickname, terms_of_service, privacy_policy 허용
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email_local, :email_domain, :nickname, :terms_of_service, :privacy_policy])
    
    # 계정 업데이트 시에도 허용
    devise_parameter_sanitizer.permit(:account_update, keys: [:email_local, :email_domain, :nickname, :terms_of_service, :privacy_policy])
  end


  def new
    super
    @minimum_password_length = Devise.password_length.first
  end
  
end

