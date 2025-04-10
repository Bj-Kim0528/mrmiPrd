class CardImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_card_image, only: [:clear]
  before_action :check_guest

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

  def check_guest
    if current_user.email == "guest@example.com"
      # 이전 페이지로 리다이렉트 (HTTP_REFERER가 없는 경우 fallback으로 root_path 사용)
      redirect_back fallback_location: root_path, alert: "게스트 유저는 이 기능을 사용할 수 없습니다." and return
    end
  end
end
