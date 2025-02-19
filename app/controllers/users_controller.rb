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

  private

  def user_params
    params.require(:user).permit(:email, :nickname, :introduction, :profile_image, :birth_date, :phone_number, :gender, :sns_link)
  end
  
end
