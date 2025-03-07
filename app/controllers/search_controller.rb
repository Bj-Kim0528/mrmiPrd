class SearchController < ApplicationController
  def index
    @query = params[:query]
    if @query.present?
      # MySQL에서는 ILIKE 대신 LIKE를 사용합니다.
      @results = CardCollection
                   .left_joins(:card_images)
                   .where("card_collections.layout LIKE :q OR card_collections.theme LIKE :q OR card_images.content LIKE :q", q: "%#{@query}%")
                   .distinct
    else
      @results = CardCollection.none
    end
  end
end