class CardCollectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_card_collection, only: [:edit, :update, :show, :destroy]

  def index
    @card_collections = CardCollection.all
  end

  def new
    @card_collection = CardCollection.new
    (10 - @card_collection.card_images.size).times { @card_collection.card_images.build }
  end

  def create
    @card_collection = current_user.card_collections.build(card_collection_params)
    if @card_collection.save
      redirect_to card_collection_path(@card_collection), notice: "카드 컬렉션이 성공적으로 생성되었습니다."
    else
      flash.now[:alert] = @card_collection.errors.full_messages.join(", ")
      render :new
    end
  end

  def edit
    @card_collection = CardCollection.find(params[:id])
    (10 - @card_collection.card_images.size).times { @card_collection.card_images.build }
  end

  def update
    if @card_collection.update(card_collection_params)
      redirect_to card_collection_path(@card_collection), notice: "카드 컬렉션이 성공적으로 업데이트되었습니다."
    else
      flash.now[:alert] = @card_collection.errors.full_messages.join(", ")
      render :edit
    end
  end

  def show
    unless @card_collection
      redirect_to card_collections_path, alert: "該当投稿を探せません"
    end
  end

  def destroy
    @card_collection.destroy
    redirect_to card_collections_path
  end

  private

  def set_card_collection
    @card_collection = CardCollection.find(params[:id])
  end

  def card_collection_params
    params.require(:card_collection).permit(
      :layout, :theme,
      card_images_attributes: [:id, :content, :image, :position, :_destroy]
    )
  end
end
