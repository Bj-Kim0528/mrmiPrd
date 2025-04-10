class BookmarksController < ApplicationController
  before_action :authenticate_user!
  before_action :check_guest

  def create
    bookmark = current_user.bookmarks.build(bookmark_params)
    if bookmark.save
      redirect_back fallback_location: root_path
    else
      redirect_back fallback_location: root_path, alert: bookmark.errors.full_messages.to_sentence
    end
  end

  def destroy
    bookmark = current_user.bookmarks.find(params[:id])
    bookmark.destroy
    redirect_back fallback_location: root_path
  end

  private

  def bookmark_params
    params.permit(:bookmarkable_type, :bookmarkable_id)
  end


  def check_guest
    if current_user.email == "guest@example.com"
      # 이전 페이지로 리다이렉트 (HTTP_REFERER가 없는 경우 fallback으로 root_path 사용)
      redirect_back fallback_location: root_path, alert: "게스트 유저는 이 기능을 사용할 수 없습니다." and return
    end
  end
end
