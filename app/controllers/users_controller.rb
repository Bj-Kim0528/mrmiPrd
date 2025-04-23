class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_owner, only: [:edit, :update]

  def show
    @userinfo = User.find(params[:id])
    if @userinfo.guest?
      flash[:alert] = "無効なページです。"
      redirect_to root_path
    end
  end

  def edit
    @userinfo = User.find(params[:id])
    if @userinfo.guest?
      flash[:alert] = "無効なページです。"
      redirect_to root_path
    end
  end

  def update
    @userinfo = User.find(params[:id])
    if @userinfo.guest?
      flash[:alert] = "無効なページです。"
      redirect_to root_path and return
    end

    if @userinfo.update(user_params)
      if params[:user][:remove_profile_image] == "true" && @userinfo.profile_image.attached?
        @userinfo.profile_image.purge
      end
      redirect_to user_path(@userinfo), notice: "プロフィールが正常に更新されました。"
    else
      flash.now[:alert] = @userinfo.errors.full_messages.join("、")
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    if current_user == @user
      @user.destroy
      reset_session
      redirect_to root_path, notice: "退会処理が完了しました。"
    else
      redirect_to user_path(@user), alert: "不正なリクエストです。"
    end
  end

  def card_collections
    @userinfo = User.find(params[:id])
    @card_collections = @userinfo.card_collections
    if @userinfo.guest?
      flash[:alert] = "無効なページです。"
      redirect_to root_path
    end
  end

  def collections
    @userinfo = User.find(params[:id])
    @card_collections = @userinfo.bookmarked_card_collections
    if @userinfo.guest?
      flash[:alert] = "無効なページです。"
      redirect_to root_path
    end
  end

  def likes
    @userinfo = User.find(params[:id])
    @card_collections = @userinfo.liked_card_collections
    if @userinfo.guest?
      flash[:alert] = "無効なページです。"
      redirect_to root_path
    end
  end

  def follower
    @userinfo = User.find(params[:id])
    @followers = @userinfo.followers
    if @userinfo.guest?
      flash[:alert] = "無効なページです。"
      redirect_to root_path
    end
  end

  def followee
    @userinfo = User.find(params[:id])
    @followees = @userinfo.following
    if @userinfo.guest?
      flash[:alert] = "無効なページです。"
      redirect_to root_path
    end
  end

  def edit_password
    @userinfo = User.find(params[:id])
    if @userinfo.guest?
      flash[:alert] = "無効なページです。"
      redirect_to root_path
    end
  end

  def update_password
    @userinfo = User.find(params[:id])
    if @userinfo.guest?
      flash[:alert] = "無効なページです。"
      return redirect_to root_path
    end
  
    if @userinfo.update_with_password(user_password_params)
      sign_out(@userinfo)
      redirect_to root_path, notice: "パスワードが正常に変更されました。再度ログインしてください。"
    else
      # 실패 시 에러 메시지를 flash에 담고 redirect
      flash[:alert] = @userinfo.errors.full_messages
      redirect_to edit_password_user_path(@userinfo)
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :nickname, :introduction, :profile_image, :birth_date, :phone_number, :gender, :sns_link)
  end

  def user_password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end

  def ensure_owner
    @userinfo = User.find(params[:id])
    unless @userinfo == current_user
      redirect_to root_path, alert: "権限がありません。"
    end
  end
end
