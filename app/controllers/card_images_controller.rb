class CardImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_guest
  before_action :set_card_image, only: [:clear]
  

  def clear

    @card_image.destroy
    if @card_collection.card_images.reload.empty?
      # 카드 이미지가 하나도 없다면, 카드 컬렉션도 삭제 후, 새로 생성하는 페이지로 리다이렉트
      @card_collection.destroy
      redirect_to new_card_collection_path, notice: "모든 이미지가 삭제되어 카드 컬렉션이 삭제되었습니다."
    else
      # 그렇지 않으면 기존의 에디트 페이지로 리다이렉트
      redirect_to edit_card_collection_path(@card_collection), notice: "이미지가 삭제되었습니다."
    end
  end


  private

  def set_card_image
    @card_image = CardImage.find(params[:id])
    @card_collection = @card_image.card_collection
  end

  def check_guest
    if current_user.email == "guest@example.com"
      # 이전 페이지로 리다이렉트 (HTTP_REFERER가 없는 경우 fallback으로 root_path 사용)
      redirect_back fallback_location: root_path, alert: "게스트 유저는 이 기능을 사용할 수 없습니다." and return
    end
  end
end
