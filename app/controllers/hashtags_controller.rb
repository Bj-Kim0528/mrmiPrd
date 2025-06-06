class HashtagsController < ApplicationController
  def show
    hashtag_name = params[:name].downcase
    if hashtag_name.match?(/\A\d+\z/)
      flash[:alert] = "해시태그는 숫자만으로 이루어질 수 없습니다."
      redirect_to root_path and return
    end

    @hashtag = Hashtag.find_or_create_by(name: hashtag_name)
    @hashtag_bookmark_count = Bookmark.where(bookmarkable_type: "Hashtag", bookmarkable_id: @hashtag.id).count
    @card_collection_count = @hashtag.card_collections.count
    @card_collections = @hashtag.card_collections.order(created_at: :desc)
  end
end
