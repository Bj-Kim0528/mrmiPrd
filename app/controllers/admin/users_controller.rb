class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def update
    @user = User.find(params[:id])
    if @user.update(admin_params)
      redirect_to admin_users_dashboard_path, notice: "ユーザーの管理者権限が更新されました。"
    else
      render :edit
    end
  end

  def destroy
      @user = User.find(params[:id])
      @user.destroy
      redirect_to admin_users_dashboard_path, notice: 'ユーザーを削除しました。'
  end

  private

  def admin_params
    params.require(:user).permit(:admin, :active)
  end
end
