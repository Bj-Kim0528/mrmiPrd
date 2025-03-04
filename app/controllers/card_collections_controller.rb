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
    submitted_photos   = params[:card_collection][:photos] || []
    new_contents       = params[:card_collection][:contents] || []
    existing_photo_ids = params[:card_collection][:existing_photo_ids] || []
  
    current_contents = @card_collection.contents || []
  
    final_contents    = []  # 최종적으로 저장할 내용 배열
    final_attachments = []  # 각 원소는 { type: :existing, blob: ... } 또는 { type: :new, file: ... }
  
    total = flags.size
    (0...total).each do |i|
      flag = flags[i].to_i
      case flag
      when 0
        # 변경 없음: 기존 첨부와 내용을 그대로 유지
        if i < existing_photo_ids.size && existing_photo_ids[i].present?
          attachment = @card_collection.photos.attachments.find_by(id: existing_photo_ids[i])
          if attachment
            final_attachments << { type: :existing, blob: attachment.blob }
            final_contents << current_contents[i]
          end
        end
      when 1
        # 신규 추가: 기존 id가 없으므로, 제출된 i번째 파일과 내용을 그대로 사용
        if submitted_photos[i].present?
          final_attachments << { type: :new, file: submitted_photos[i] }
          final_contents << new_contents[i].to_s.strip
        end
      when 3
        # 수정: 기존 필드 수정. 파일이 선택되었으면 교체, 없으면 내용만 수정.
        if i < existing_photo_ids.size && existing_photo_ids[i].present?
          attachment = @card_collection.photos.attachments.find_by(id: existing_photo_ids[i])
          if submitted_photos[i].present?
            # 파일 선택이 있으면 기존 첨부 교체
            attachment.purge if attachment
            final_attachments << { type: :new, file: submitted_photos[i] }
            final_contents << new_contents[i].to_s.strip
          else
            # 파일 없이 내용만 수정 (빈 문자열도 반영)
            if attachment
              final_attachments << { type: :existing, blob: attachment.blob }
              final_contents << new_contents[i].to_s.strip
            end
          end
        end
      when 2
        # 삭제: 해당 인덱스의 기존 첨부가 있으면 purge 처리하고, 최종 결과에는 포함하지 않음.
        if i < existing_photo_ids.size && existing_photo_ids[i].present?
          attachment = @card_collection.photos.attachments.find_by(id: existing_photo_ids[i])
          attachment.purge if attachment
        end
        # 해당 인덱스는 최종 배열에 추가하지 않음.
      end
    end
  
    # 모델에 최종 내용 배열 업데이트
    @card_collection.contents = final_contents
  
    # 기존 첨부를 모두 detach하여 순서를 재구성할 준비 (detach는 인수 없이 호출)
    @card_collection.photos.detach
  
    # 최종 배열 순서대로 첨부파일 재attach
    final_attachments.each do |item|
      if item[:type] == :new
        @card_collection.photos.attach(item[:file])
      else
        @card_collection.photos.attach(item[:blob])
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
