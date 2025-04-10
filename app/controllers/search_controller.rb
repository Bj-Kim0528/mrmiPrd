class SearchController < ApplicationController
  def index
    @query = params[:query]

    if @query.present?
      # 1. 컨텐츠 검색: CardImage의 content에서 검색어가 포함된 CardCollection
      @content_results = CardCollection
                           .joins(:card_images)
                           .where("card_images.content LIKE ?", "%#{@query}%")
                           .distinct

      # 2. 유저 검색: 유저의 nickname과, 그 유저가 작성한 CardCollection
      @user_results = User
                        .where("nickname LIKE ?", "%#{@query}%")
                        .where.not(email: "guest@example.com") 
      # 해당 유저가 작성한 게시물들 (여러 유저의 결과를 하나의 CardCollection으로 모음)
      @user_card_collections = CardCollection.where(user: @user_results)

      # 3. 해시태그 검색: Hashtag에서 검색 후, 해당 해시태그가 붙은 CardCollection
      @hashtag_results = Hashtag.where("name LIKE ?", "%#{@query}%")
      @hashtag_card_collections = CardCollection
                                    .joins(:card_collection_hashtags)
                                    .where(card_collection_hashtags: { hashtag_id: @hashtag_results.pluck(:id) })
                                    .distinct
    else
      @content_results = CardCollection.none
      @user_results = User.none
      @user_card_collections = CardCollection.none
      @hashtag_results = Hashtag.none
      @hashtag_card_collections = CardCollection.none
    end
  end


  def photos
    @query = params[:query]
    if @query.present?
      @content_results = CardCollection
                           .joins(:card_images)
                           .where("card_images.content LIKE ?", "%#{@query}%")
                           .distinct
    else
      @content_results = CardCollection.none
    end
    render :photos
  end

  def users
    @query = params[:query]
    if @query.present?
      @user_results = User
        .where("nickname LIKE ?", "%#{@query}%")
        .where.not(email: "guest@example.com")    # 게스트 유저 제외 조건
      @user_card_collections = CardCollection.where(user: @user_results)
    else
      @user_results = User.none
      @user_card_collections = CardCollection.none
    end
    render :users
  end

  def hashtags
    @query = params[:query]
    if @query.present?
      @hashtag_results = Hashtag.where("name LIKE ?", "%#{@query}%")
      @hashtag_card_collections = CardCollection
                                    .joins(:card_collection_hashtags)
                                    .where(card_collection_hashtags: { hashtag_id: @hashtag_results.pluck(:id) })
                                    .distinct
    else
      @hashtag_results = Hashtag.none
      @hashtag_card_collections = CardCollection.none
    end
    render :hashtags
  end
end
