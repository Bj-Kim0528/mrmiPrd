class CardCollectionsController < ApplicationController
  before_action :authenticate_user! 

  def index
    @card_collections = CardCollection.all
  end

  def new
    @card_collection = CardCollection.new
  end

  # POST /card_collections
  def create
    @card_collection = current_user.card_collections.build(card_collection_params)
    if @card_collection.save
      redirect_to card_collections_path, notice: "카드 컬렉션이 성공적으로 생성되었습니다."
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def show
  end


  private

  def card_collection_params
    params.require(:card_collection).permit(:content, :layout, :theme, photos: [])
  end
end
