class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_owner, only: [:edit, :update]

  def show
    @userinfo = User.find(params[:id])
    if @userinfo.guest?
      flash[:alert] = "잘못된 페이지 입니다."
      redirect_to root_path
    end
  end

  def edit
    @userinfo = User.find(params[:id])
    if @userinfo.guest?
      flash[:alert] = "잘못된 페이지 입니다."
      redirect_to root_path
    end
  end

  def update
    @userinfo = User.find(params[:id])
    if @userinfo.guest?
      flash[:alert] = "잘못된 페이지 입니다."
      redirect_to root_path
    end

    if @userinfo.update(user_params)
      if params[:user][:remove_profile_image] == "true" && @userinfo.profile_image.attached?
        @userinfo.profile_image.purge
      end
      redirect_to user_path(@userinfo)
    else
      render :edit
    end
  end


  def destroy
    @user = User.find(params[:id])
    # 실제 삭제 로직
    # 예: user가 현재 로그인한 사용자와 일치하는지 확인 후 삭제
    if current_user == @user
      @user.destroy
      reset_session  # 사용자를 로그아웃시키고 싶다면 세션 리셋
      redirect_to root_path, notice: "탈퇴 처리되었습니다."
    else
      redirect_to user_path(@user), alert: "잘못된 요청입니다."
    end
  end



  def card_collections
    @userinfo = User.find(params[:id])
    @card_collections = @userinfo.card_collections
    if @userinfo.guest?
      flash[:alert] = "잘못된 페이지 입니다."
      redirect_to root_path
    end
  end

  def collections
    @userinfo = User.find(params[:id])
    @card_collections = @userinfo.bookmarked_card_collections
    if @userinfo.guest?
      flash[:alert] = "잘못된 페이지 입니다."
      redirect_to root_path
    end
  end

  def likes
    @userinfo = User.find(params[:id])
    @card_collections = @userinfo.liked_card_collections
    if @userinfo.guest?
      flash[:alert] = "잘못된 페이지 입니다."
      redirect_to root_path
    end
  end

  def follower
    @userinfo = User.find(params[:id])
    @followers = @userinfo.followers
    if @userinfo.guest?
      flash[:alert] = "잘못된 페이지 입니다."
      redirect_to root_path
    end
  end

  def followee
    @userinfo = User.find(params[:id])
    @followees = @userinfo.following
    if @userinfo.guest?
      flash[:alert] = "잘못된 페이지 입니다."
      redirect_to root_path
    end
  end

  def edit_password
    @userinfo = User.find(params[:id])
    if @userinfo.guest?
      flash[:alert] = "잘못된 페이지 입니다."
      redirect_to root_path
    end
  end

  def update_password
    @userinfo = User.find(params[:id])
    if @userinfo.guest?
      flash[:alert] = "잘못된 페이지 입니다."
      redirect_to root_path and return
    end
  
    # 현재 비밀번호와 새 비밀번호, 비밀번호 확인을 받아 업데이트
    if @userinfo.update_with_password(user_password_params)
      # 비밀번호 변경 후 현재 세션을 종료합니다.
      sign_out(@userinfo)
      redirect_to root_path, notice: "비밀번호가 성공적으로 변경되었습니다. 다시 로그인해주세요."
    else
      flash.now[:alert] = @userinfo.errors.full_messages.join(", ")
      render :edit_password
    end
  end



  
  private

  def user_params
    params.require(:user).permit(:email, :nickname, :introduction, :profile_image, :birth_date, :phone_number, :gender, :sns_link)
  end

  def user_password_params
    # :current_password가 반드시 포함되어야 합니다.
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end

  def ensure_owner
    @userinfo = User.find(params[:id])
    unless @userinfo == current_user
      redirect_to root_path, alert: "해당 작업을 수행할 권한이 없습니다."
    end
  end
  
end
