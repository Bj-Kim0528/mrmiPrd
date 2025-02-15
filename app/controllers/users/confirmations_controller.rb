# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  def new
  end

  # 사용자가 입력한 인증번호를 검증하는 액션
  def create
    token = params[:confirmation_token]
    user = User.confirm_by_token(token)
    if user.errors.empty?
      flash[:notice] = "이메일 인증이 완료되었습니다."
      sign_in(user)
      redirect_to root_path
    else
      flash.now[:alert] = "인증번호가 올바르지 않습니다. 다시 입력해주세요."
      render :new
    end
  end

  # GET /users/confirmations/certification
  def certification
    # 인증번호 입력 폼을 렌더링합니다.
    # (뷰 파일은 app/views/users/confirmations/certification.html.erb 로 생성)
  end

  def certificate
    email = params[:email]
    password = params[:password]
    token = params[:confirmation_token]

    user = User.find_by(email: email)
    if user && user.valid_password?(password) && user.confirmation_token == token
      user.update(confirmed_at: Time.current)
      flash[:notice] = "이메일 인증이 완료되었습니다."
      sign_in(user)
      redirect_to root_path
    else
      flash.now[:alert] = "입력한 정보가 올바르지 않습니다. 다시 시도해주세요."
      render :new
    end
  end
end
