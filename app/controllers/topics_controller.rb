class TopicsController < ApplicationController
  def show
    @theme = params[:theme]
    # 테마가 a, b, c, d 중 하나인지 검증할 수도 있습니다.
    @card_collections = CardCollection.where(theme: @theme)
  end

  def hashtag_channel
    @hashtags = Hashtag.all
  end

  def recommend
    # 테마가 お部屋写真인 카드 컬렉션
    @card_collections_room_photo = CardCollection.where(theme: "お部屋写真").sort_by do |cc|
      total_interactions = cc.likes.count +
                          cc.bookmarks.count +
                          cc.card_collection_comments.where(deleted: false).count +
                          CardCollectionReply.joins(:card_collection_comment)
                                              .where(card_collection_comments: { card_collection_id: cc.id }, deleted: false)
                                              .count +
                          cc.view_count
      -total_interactions  # 내림차순 정렬을 위해 음수로 반환
    end

    # 테마가 その他인 카드 컬렉션
    @card_collections_other = CardCollection.where(theme: "その他").sort_by do |cc|
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
