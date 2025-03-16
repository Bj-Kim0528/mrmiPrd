# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  # reset_password 이메일 발송 후 리다이렉트 경로를 재정의합니다.
  protected

  # 비밀번호 재설정 이메일 발송 후 사용자가 수동으로 토큰을 입력할 수 있도록 인증번호 입력 페이지로 리다이렉트
  def after_sending_reset_password_instructions_path_for(resource_name)
    password_certification_path
  end

  public

  # 인증번호(토큰) 입력 폼을 표시하는 액션
  def certification
    # 사용자가 이메일로 받은 reset 토큰을 직접 입력할 수 있는 폼을 렌더링합니다.
    # 예: app/views/users/passwords/certification.html.erb
  end

  # 사용자가 입력한 토큰을 검증하여 비밀번호 재설정 페이지(edit action)로 리다이렉트하는 액션
  def verify_token
    token = params[:reset_password_token]
    # 토큰을 통해 사용자를 찾습니다. (업데이트는 하지 않고 단순 조회만)
    self.resource = resource_class.with_reset_password_token(token)
  
    if resource.present? && resource.reset_password_period_valid?
      # 토큰이 유효하면 edit 페이지로 리다이렉트
      redirect_to edit_user_password_path(reset_password_token: token)
    else
      flash.now[:alert] = "토큰이 유효하지 않거나 만료되었습니다."
      render :certification
    end
  end
end
