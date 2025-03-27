class BookmarksController < ApplicationController
  before_action :authenticate_user!

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
end
