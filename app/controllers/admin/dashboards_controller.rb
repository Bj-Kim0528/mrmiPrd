class Admin::DashboardsController < ApplicationController
  layout 'admin'
  before_action :require_admin
  before_action :authenticate_admin!
  def index
      @users = User.all
  end


  private

  def require_admin
    unless current_user.admin?
      redirect_to root_path, alert: "접근 권한이 없습니다."
    end
  end
end
