class CardCollectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_card_collection, only: [:edit, :update, :show, :destroy]

  def index
    @card_collections = CardCollection.all
  end

  def new
    @card_collection = CardCollection.new
  end

  def create
    @card_collection = current_user.card_collections.build(card_collection_params)
    if @card_collection.save
      redirect_to card_collections_path, notice: "카드 컬렉션이 성공적으로 생성되었습니다."
    else
      render :new
    end
  end

  def edit
    # 기존 데이터를 뷰에 렌더링
  end

  def update
    # 폼으로부터 전달된 새 파일, 내용, 기존 파일 id
    new_photos          = params[:card_collection][:photos] || []
    new_contents        = params[:card_collection][:contents] || []
    existing_photo_ids  = params[:card_collection][:existing_photo_ids] || []
    old_contents        = @card_collection.contents || []

    # 새 내용이 비어 있으면 기존 내용을 유지하도록 병합
    merged_contents = new_contents.each_with_index.map do |new_content, index|
      new_content.present? ? new_content : (old_contents[index] || "")
    end

    if @card_collection.update(card_collection_params_without_photos.merge(contents: merged_contents))
      new_photos.each_with_index do |uploaded_file, index|
        # 기존 파일이 있었는지 여부 (hidden 필드가 있다면 기존 파일로 간주)
        existing_photo_id = existing_photo_ids[index]
        if uploaded_file.present?
          # 기존 파일이 존재하면 해당 첨부를 교체
          if existing_photo_id.present?
            attachment = @card_collection.photos.attachments.find_by(id: existing_photo_id)
            attachment.purge if attachment
          end
          @card_collection.photos.attach(uploaded_file)
        end
      end
      redirect_to card_collections_path, notice: "카드 컬렉션이 성공적으로 업데이트되었습니다."
    else
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
    @card_collection = CardCollection.find_by(id: params[:id])
  end

  # photos는 update 시 별도 로직으로 처리하므로 제외
  def card_collection_params_without_photos
    permitted = params.require(:card_collection).permit(:layout, :theme, contents: [])
    permitted[:contents] = permitted[:contents].map { |c| c.presence || "" } if permitted[:contents].present?
    permitted
  end

  def card_collection_params
    permitted = params.require(:card_collection).permit(:layout, :theme, photos: [], contents: [])
    permitted[:contents] = permitted[:contents].map { |c| c.presence || "" } if permitted[:contents].present?
    permitted
  end
end
