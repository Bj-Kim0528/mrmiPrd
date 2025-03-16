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

    # Devise 내부 메서드를 사용하여 토큰을 찾습니다.
    self.resource = resource_class.reset_password_by_token(reset_password_token: token)

    if resource.errors.empty?
      # 토큰이 유효하면 edit 페이지로 리다이렉트
      redirect_to edit_user_password_path(reset_password_token: token)
    else
      # 유효하지 않으면 인증번호 입력 폼을 다시 렌더링하면서 에러 메시지를 표시
      flash.now[:alert] = resource.errors.full_messages.join(", ")
      render :certification
    end
  end
end
