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
  
    current_contents = @card_collection.contents || []
  
    # 최종적으로 남길 내용과 첨부 순서를 담을 배열
    final_contents = []
    final_attachments = [] # 각 원소는 { type: :existing, blob: ... } 또는 { type: :new, file: ... }
  
    total = flags.size
  
    (0...total).each do |i|
      flag = flags[i].to_i
      case flag
      when 0
        # 변경 없음 → 기존 첨부와 내용을 그대로 유지
        if i < existing_photo_ids.size && existing_photo_ids[i].present?
          attachment = @card_collection.photos.attachments.find_by(id: existing_photo_ids[i])
          if attachment
            final_attachments << { type: :existing, blob: attachment.blob }
            # 내용은 새로 전달된 값이 있으면 사용하고, 없으면 기존 내용을 사용
            final_contents << (new_contents[i].strip.presence || current_contents[i])
          end
        end
      when 1
        # 수정/추가
        if i < existing_photo_ids.size && existing_photo_ids[i].present?
          # 기존 필드의 수정: 만약 새 파일이 업로드되었다면 기존 첨부를 교체
          attachment = @card_collection.photos.attachments.find_by(id: existing_photo_ids[i])
          if new_photos[i].present?
            # 기존 첨부 교체: 기존 첨부는 purge (완전 삭제)
            attachment.purge if attachment
            final_attachments << { type: :new, file: new_photos[i] }
            final_contents << new_contents[i].strip.presence || ""
          else
            # 파일은 그대로 두고 내용만 업데이트 (변경 없음처럼 처리)
            if attachment
              final_attachments << { type: :existing, blob: attachment.blob }
              final_contents << (new_contents[i].strip.presence || current_contents[i])
            end
          end
        else
          # 신규 추가 필드 (기존 id 없음)
          if new_photos[i].present?
            final_attachments << { type: :new, file: new_photos[i] }
            final_contents << new_contents[i].strip.presence || ""
          end
        end
      when 2
        # 삭제 → 기존 첨부가 있으면 purge 처리; 해당 필드는 최종 결과에 포함하지 않음.
        if i < existing_photo_ids.size && existing_photo_ids[i].present?
          attachment = @card_collection.photos.attachments.find_by(id: existing_photo_ids[i])
          attachment.purge if attachment
        end
        # final_contents 에 추가하지 않음.
      end
    end
  
    # 업데이트할 contents 배열 재설정
    @card_collection.contents = final_contents
  
    # detach(연관관계 해제) : 기존 첨부들을 모두 detach하여 순서를 재구성할 수 있도록 함.
    @card_collection.photos.each do |att|
      @card_collection.photos.detach(att)
    end
  
    # 최종 순서대로 첨부파일 재attach
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
