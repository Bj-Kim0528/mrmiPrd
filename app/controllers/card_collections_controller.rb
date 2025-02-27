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
    @card_collection = CardCollection.find_by(id: params[:id])
  end

  def update
    @card_collection = CardCollection.find(params[:id])
    new_photos = params[:card_collection][:photos]      # 배열 형태의 새 파일들
    delete_flags = params[:card_collection][:delete_flags]  # 각 필드에 대한 삭제 플래그 배열
  
    if @card_collection.update(card_collection_update_params)
      if new_photos.present? && delete_flags.present?
        new_photos.each_with_index do |new_file, i|
          # 새 파일이 선택되었으면, 기존 파일을 교체합니다.
          if new_file.present?
            if @card_collection.photos.attached? && @card_collection.photos[i]
              @card_collection.photos[i].purge   # 기존 파일 삭제
            end
            @card_collection.photos.attach(new_file)  # 새 파일 첨부
          else
            # 새 파일이 없고, 삭제 플래그가 "1"이면 기존 파일 삭제
            if delete_flags[i] == "1" && @card_collection.photos.attached? && @card_collection.photos[i]
              @card_collection.photos[i].purge
            end
          end
        end
      end
      redirect_to card_collections_path, notice: "Card collection was successfully updated."
    else
      render :edit
    end
  end

  def show
    @card_collection = CardCollection.find_by(id: params[:id])
    unless @card_collection
      redirect_to card_collections_path, alert: "該当投稿を探せません"
    end
  end

  def destroy
    card_collection = CardCollection.find_by(id: params[:id])
    card_collection.destroy
    redirect_to card_collections_path
  end


  private

  def card_collection_params
    permitted = params.require(:card_collection).permit(:layout, :theme, photos: [], contents: [])
    # 빈 문자열을 포함하는 배열로 강제 저장 (원한다면)
    permitted[:contents] = permitted[:contents].map { |c| c.presence || "" }
    permitted
  end

  def card_collection_update_params
    permitted = params.require(:card_collection).permit(:layout, :theme, contents: [])
    permitted[:contents] = permitted[:contents].map { |c| c.presence || "" }
    permitted
  end
end
