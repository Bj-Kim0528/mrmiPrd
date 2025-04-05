class TopicsController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @theme = Theme.find_by(name: params[:theme_name])
    # 테마가 a, b, c, d 중 하나인지 검증할 수도 있습니다.
    @card_collections = CardCollection.where(theme_id: @theme)
  end

  def hashtag_channel
    @hashtags = Hashtag.all
  end

  def recommend
    @room_photo_theme = Theme.find_by(name: "お部屋写真")
    @other_theme = Theme.find_by(name: "その他")
  
    @card_collections_room_photo = CardCollection.where(theme_id: @room_photo_theme.id).sort_by do |cc|
      total_interactions = cc.likes.count +
                           cc.bookmarks.count +
                           cc.card_collection_comments.where(deleted: false).count +
                           CardCollectionReply.joins(:card_collection_comment)
                                              .where(card_collection_comments: { card_collection_id: cc.id }, deleted: false)
                                              .count +
                           cc.view_count
      -total_interactions  # 내림차순 정렬을 위해 음수값 반환
    end
  
    @card_collections_other = CardCollection.where(theme_id: @other_theme.id).sort_by do |cc|
      total_interactions = cc.likes.count +
                           cc.bookmarks.count +
                           cc.card_collection_comments.where(deleted: false).count +
                           CardCollectionReply.joins(:card_collection_comment)
                                              .where(card_collection_comments: { card_collection_id: cc.id }, deleted: false)
                                              .count +
                           cc.view_count
      -total_interactions
    end
  end
end
