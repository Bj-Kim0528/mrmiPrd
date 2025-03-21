class UsersController < ApplicationController
  def show
    @userinfo = User.find(params[:id])
  end

  def edit
    @userinfo = User.find(params[:id])
  end

  def update
    @userinfo = User.find(params[:id])
    if @userinfo.update(user_params)
      flash[:notice] = "You have updated user successfully." 
      redirect_to user_path(@userinfo)
    else
      render :edit
    end
  end



  def card_collections
    @userinfo = User.find(params[:id])
    @card_collections = @userinfo.card_collections
  end

  def collections
    @userinfo = User.find(params[:id])
    @card_collections = @userinfo.bookmarked_card_collections
  end

  def likes
    @userinfo = User.find(params[:id])
    @card_collections = @userinfo.liked_card_collections
  end

  def follower
    @userinfo = User.find(params[:id])
    @followers = @userinfo.followers
  end

  def followee
    @userinfo = User.find(params[:id])
    @followees = @userinfo.following
  end

  def edit_password
    @userinfo = User.find(params[:id])
  end

  def update_password
    @userinfo = User.find(params[:id])
    # 현재 비밀번호와 새 비밀번호, 비밀번호 확인을 받아 업데이트
    if @userinfo.update_with_password(user_password_params)
      # 비밀번호 변경 후, 현재 세션 유지(Devise의 bypass_sign_in 사용)
      bypass_sign_in(@userinfo)
      redirect_to user_path(@userinfo), notice: "비밀번호가 성공적으로 변경되었습니다."
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
  
end
