class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def create
    bookmark = current_user.bookmarks.build(bookmark_params)
    if bookmark.save
      redirect_back fallback_location: root_path, notice: '북마크를 추가했습니다.'
    else
      redirect_back fallback_location: root_path, alert: bookmark.errors.full_messages.to_sentence
    end
  end

  def destroy
    bookmark = current_user.bookmarks.find(params[:id])
    bookmark.destroy
    redirect_back fallback_location: root_path, notice: '북마크를 취소했습니다.'
  end

  private

  def bookmark_params
    params.permit(:card_collection_id)
  end
end