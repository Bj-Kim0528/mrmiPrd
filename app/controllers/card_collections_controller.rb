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
    # 1. 새 파일 업로드 값은 변수에 저장합니다.
    new_photos = params[:card_collection][:photos] || []
  
    # 2. photos 키를 params에서 삭제하여 자동으로 빈 배열이 할당되는 것을 방지합니다.
    params[:card_collection].delete(:photos)
    
    # 3. contents 관련 처리 (수정하지 않은 필드는 기존 값 유지)
    new_contents       = params[:card_collection][:contents] || []
    existing_photo_ids = params[:card_collection][:existing_photo_ids] || []
    old_contents       = @card_collection.contents || []
    
    merged_contents = new_contents.each_with_index.map do |new_content, index|
      new_content.present? ? new_content : (old_contents[index] || "")
    end
  
    if @card_collection.update(card_collection_params_without_photos.merge(contents: merged_contents))
      # 4. 새 파일이 업로드된 필드만 처리합니다.
      new_photos.each_with_index do |uploaded_file, index|
        if uploaded_file.present?
          # 해당 인덱스에 기존 첨부가 있다면 삭제 후 교체
          if existing_photo_ids[index].present?
            attachment = @card_collection.photos.attachments.find_by(id: existing_photo_ids[index])
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
