class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:top, :about], unless: :admin_controller? # 追加
  before_action :configure_permitted_parameters, if: :devise_controller?
#   before_action :configure_permitted_parameters, if: :devise_controller?

#   protected

#  def configure_permitted_parameters
#      devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])
#  end
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  private
 
  def admin_controller?
    self.class.module_parent_name == 'Admin'
  end

  protected
 
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email])
  end
end
