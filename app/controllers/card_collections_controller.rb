class CardCollectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_card_collection, only: [:edit, :update, :show, :destroy]
  before_action :ensure_owner, only: [:edit, :update, :destroy]

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
    (10 - @card_collection.card_images.size).times { @card_collection.card_images.build }
  end

  def update
    deletion_occurred = false

    if params[:clear_card_image].present?
      card_image_id = params[:clear_card_image]
      card_image = @card_collection.card_images.find(card_image_id)
      deletion_occurred = card_image.update(image: nil, content: nil)
    end
  
    if @card_collection.update(card_collection_params)
      if deletion_occurred
        redirect_to edit_card_collection_path(@card_collection), notice: "이미지가 삭제되었습니다."
      else
        redirect_to card_collection_path(@card_collection), notice: "카드 컬렉션이 성공적으로 업데이트되었습니다."
      end
    else
      flash.now[:alert] = @card_collection.errors.full_messages.join(", ")
      render :edit
    end
  end

  def show
    @card_collection.increment!(:view_count)
    unless @card_collection
      redirect_to card_collections_path, alert: "該当投稿を探せません"
    end
    @comments = @card_collection.card_collection_comments.order(created_at: :asc)
    @card_collection_comment = @card_collection.card_collection_comments.build
  end

  def destroy
    @card_collection.destroy
    redirect_to card_collections_path
  end

  private

  def set_card_collection
    @card_collection = CardCollection.find(params[:id])
  end

  def ensure_owner
    unless @card_collection.user == current_user
      redirect_to card_collections_path, alert: "해당 작업을 수행할 권한이 없습니다."
    end
  end

  def card_collection_params
    params.require(:card_collection).permit(
      :layout, :theme_id,
      card_images_attributes: [:id, :content, :image, :position, :_destroy]
    )
  end
end
