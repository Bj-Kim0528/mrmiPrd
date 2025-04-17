class HomesController < ApplicationController
  def top
    @room_photo_theme = Theme.find_by(name: "お部屋写真")
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
    themes = Theme.where.not(name: ["お部屋写真", "その他"])
    # Ruby Array 로 변환 후 shuffle & sample
    @random_themes = themes.to_a.shuffle.take(3)
  end

  def about
  end
end
