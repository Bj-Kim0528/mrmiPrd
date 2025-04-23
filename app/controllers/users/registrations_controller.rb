class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :clear_omniauth_data, only: [:new]




  def new
    super
    @minimum_password_length = Devise.password_length.first
  end



  # SNS 회원가입 폼 전용 액션 (new)
  def sns_sign_up
    if session["devise.google_data"]
      omniauth_data = session["devise.google_data"]
      resource_attributes = {
        email: omniauth_data.dig("info", "email"),
        nickname: omniauth_data.dig("info", "name"),
        provider: omniauth_data["provider"],
        uid: omniauth_data["uid"]
      }
      build_resource(resource_attributes)
    else
      build_resource({})
    end
    render "devise/registrations/sns_sign_up"
  end

  # 오버라이드: SNS 회원가입을 처리하는 create 액션
  def create
    if session["devise.google_data"]
      omniauth_data = session["devise.google_data"]
      # 폼에서 전달된 파라미터와 Omniauth 데이터를 병합합니다.
      resource_attributes = {
        email: omniauth_data.dig("info", "email"),
        nickname: omniauth_data.dig("info", "name"),  # 여기서 name 대신 nickname 사용
        provider: omniauth_data["provider"],
        uid: omniauth_data["uid"]
      }
      # 사용자가 폼에서 입력한 파라미터도 merge합니다.
      resource_attributes.merge!(sign_up_params)
      build_resource(resource_attributes)
      
      # SNS 회원가입의 경우, 이메일 인증 절차를 건너뜁니다.
      resource.skip_confirmation!
  
      resource.save
      yield resource if block_given?
      if resource.persisted?
        # 세션 데이터는 삭제
        session.delete("devise.google_data")
        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        flash[:alert] = resource.errors.full_messages
        redirect_to sns_sign_up_path
      end
    else
      super
    end
  end





  protected

  # 회원가입 후, 사용자가 아직 확인되지 않았으므로
  # after_inactive_sign_up_path_for를 재정의하여 인증번호 입력 페이지로 리다이렉트합니다.
  def after_inactive_sign_up_path_for(resource)
    # 이메일 인증 페이지 접근 허용 플래그
    session[:allow_confirmation] = true
    # 이메일 인증번호 입력 폼(new) 경로
    new_user_confirmation_path
  end

  def configure_permitted_parameters
    # 회원가입 시 email_local, email_domain, nickname, terms_of_service, privacy_policy 허용
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email_local, :email_domain, :nickname, :terms_of_service, :privacy_policy])
    
    # 계정 업데이트 시에도 허용
    devise_parameter_sanitizer.permit(:account_update, keys: [:email_local, :email_domain, :nickname, :terms_of_service, :privacy_policy])
  end


  def sign_up_params
    params.require(:user).permit(:email, :email_local, :email_domain, :nickname, :password, :password_confirmation, :terms_of_service, :privacy_policy)
  end

  private

  def clear_omniauth_data
    session.delete("devise.google_data")
  end
  
end

