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
    # 기존 데이터를 뷰에 렌더링 (사진은 url_for를 이용하여 미리보기)
  end

  def update
    # 폼으로부터 전달된 새 배열 값들
    new_photos   = params[:card_collection][:photos] || []
    new_contents = params[:card_collection][:contents] || []
    old_contents = @card_collection.contents || []

    # 새 내용이 비어있으면 기존 내용을 유지
    merged_contents = new_contents.each_with_index.map do |new_content, index|
      new_content.present? ? new_content : (old_contents[index] || "")
    end

    # photos 관련 파라미터는 별도로 처리하기 위해 strong parameters에서 제외
    if @card_collection.update(card_collection_params_without_photos.merge(contents: merged_contents))
      # 사진 배열에 대해 각 인덱스별로 새 파일이 있으면 교체, 없으면 기존 첨부 유지
      new_photos.each_with_index do |uploaded_file, index|
        next if uploaded_file.blank?
        # 기존 첨부가 있다면 해당 첨부를 교체
        if @card_collection.photos.attachments[index]
          @card_collection.photos.attachments[index].purge
        end
        @card_collection.photos.attach(uploaded_file)
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

  # 사진(ActiveStorage)와 내용을 동시에 업데이트하면 기존 첨부가 빈 배열로 덮어쓰여질 수 있으므로
  # 사진 관련 파라미터는 제외한 strong parameters를 별도로 만듭니다.
  def card_collection_params_without_photos
    permitted = params.require(:card_collection).permit(:layout, :theme, contents: [])
    permitted[:contents] = permitted[:contents].map { |c| c.presence || "" } if permitted[:contents].present?
    permitted
  end

  # create 시 사용되는 strong parameters (업로드된 파일이 있다면 모두 저장)
  def card_collection_params
    permitted = params.require(:card_collection).permit(:layout, :theme, photos: [], contents: [])
    permitted[:contents] = permitted[:contents].map { |c| c.presence || "" } if permitted[:contents].present?
    permitted
  end
end
