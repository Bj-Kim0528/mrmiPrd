class Admin::DashboardsController < ApplicationController
  layout 'admin'
  before_action :require_admin
  before_action :authenticate_admin!
  def index
      @users = User.all
  end


  private

  def require_admin
    unless current_user && current_user.admin?
      redirect_to root_path, alert: "관리자만 접근할 수 있습니다."
    end
  end
end
