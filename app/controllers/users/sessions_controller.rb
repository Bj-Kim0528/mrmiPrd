# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  def guest_sign_in
    user = User.guest
    if user.present?
      sign_in user
      redirect_to root_path, notice: '게스트 로그인 되었습니다!'
    else
      redirect_to new_user_session_path, alert: '게스트 로그인에 실패했습니다.'
    end
  end

  def destroy
    if current_user.guest?
      current_user.destroy 
      reset_session 
    end
    super 
  end
end
