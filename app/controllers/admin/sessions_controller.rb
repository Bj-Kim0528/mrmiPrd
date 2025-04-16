# frozen_string_literal: true

class Admin::SessionsController < Devise::SessionsController
  layout 'admin'
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  def after_sign_in_path_for(resource)
    admin_users_dashboard_path # ログイン後にリダイレクトするパス
  end

   def after_sign_out_path_for(resource_or_scope)
    admin_users_dashboard_path # ログアウト後にリダイレクトするパス
   end
end
