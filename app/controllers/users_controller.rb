class UsersController < ApplicationController
  def show
      @userinfo = User.find(params[:id])
  end

  def edit
  end

  def update
  end

  private

  def user_params
    params.require(:user).permit(:email, :nickname, :introduction, :profile_image, :birth_date, :phone_number, :gender, :sns_link)
  end
  
end
