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
    flags              = params[:card_collection][:flags] || []
    new_photos         = params[:card_collection][:photos] || []
    new_contents       = params[:card_collection][:contents] || []
    existing_photo_ids = params[:card_collection][:existing_photo_ids] || []
    
    # 기존의 contents 배열 (순서가 일치한다고 가정)
    current_contents = @card_collection.contents || []
    
    final_contents = []   # 최종적으로 남을 contents 배열
    final_blobs    = []   # 최종 순서대로 첨부할 ActiveStorage::Blob 또는 업로드 파일
    
    # 인덱스별 처리
    flags.each_with_index do |flag, i|
      case flag.to_i
      when 0
        # 변경 없음 → 기존 필드 유지 (기존 첨부와 내용 그대로)
        if existing_photo_ids[i].present?
          attachment = @card_collection.photos.attachments.find_by(id: existing_photo_ids[i])
          if attachment
            final_blobs << attachment.blob
            # 기존 내용은 그대로 사용 (배열 순서 유지)
            final_contents << current_contents[i]
          end
        end
      when 1
        # 수정/추가 → 새 파일이 있으면 해당 파일로 교체, 없으면 내용만 수정
        if existing_photo_ids[i].present?
          # 기존 필드의 수정인 경우
          if new_photos[i].present?
            # 새 파일 업로드 → 새 파일로 대체
            final_blobs << new_photos[i]  # 파일 객체 (나중에 attach)
            final_contents << new_contents[i].presence || ""
          else
            # 파일 변경 없이 내용만 수정
            attachment = @card_collection.photos.attachments.find_by(id: existing_photo_ids[i])
            if attachment
              final_blobs << attachment.blob
              final_contents << new_contents[i].presence || current_contents[i]
            end
          end
        else
          # 신규 추가 필드
          if new_photos[i].present?
            final_blobs << new_photos[i]
            final_contents << new_contents[i].presence || ""
          end
        end
      when 2
        # 삭제 → 아무것도 추가하지 않음; 기존 첨부가 있으면 삭제 처리
        if existing_photo_ids[i].present?
          attachment = @card_collection.photos.attachments.find_by(id: existing_photo_ids[i])
          attachment.purge if attachment
        end
        # 해당 인덱스는 최종 결과에 포함하지 않음.
      end
    end
    
    # 업데이트할 contents 배열 재설정
    @card_collection.contents = final_contents
    
    # 기존의 모든 첨부파일을 제거한 후 최종 순서대로 재첨부
    @card_collection.photos.purge
    
    final_blobs.each do |item|
      # item이 업로드 파일 객체이면 그대로 attach, 그렇지 않으면 (기존 blob) attach
      if item.respond_to?(:read)
        @card_collection.photos.attach(item)
      else
        @card_collection.photos.attach(item)
      end
    end
    
    if @card_collection.save
      redirect_to card_collection_path(@card_collection), notice: "카드 컬렉션이 성공적으로 업데이트되었습니다."
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
