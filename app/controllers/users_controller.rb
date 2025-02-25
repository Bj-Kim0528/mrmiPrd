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
  end

  def collections
    @userinfo = User.find(params[:id])
  end

  def likes
    @userinfo = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:email, :nickname, :introduction, :profile_image, :birth_date, :phone_number, :gender, :sns_link)
  end

  def set_userinfo
    @userinfo = User.find(params[:id])
  end
  
end
