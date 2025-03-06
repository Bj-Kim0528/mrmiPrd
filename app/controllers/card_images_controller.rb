class CardImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_card_image, only: [:clear]

  def clear
    # 첨부된 이미지가 있다면 제거
    @card_image.image.purge if @card_image.image.attached?
    # 컨텐츠를 nil로 업데이트
    @card_image.update(content: nil)
    redirect_back(fallback_location: card_collection_path(@card_image.card_collection), notice: "데이터가 삭제되었습니다.")
  end


  private

  def set_card_image
    @card_image = CardImage.find(params[:id])
  end
end
