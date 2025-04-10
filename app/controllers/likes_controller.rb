class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_guest

  def create
    # 파라미터로 전달된 likeable_type과 likeable_id를 통해 대상 객체를 찾습니다.
    likeable = params[:likeable_type].constantize.find(params[:likeable_id])
    @like = current_user.likes.build(likeable: likeable)
    
    if @like.save
      redirect_back(fallback_location: root_path, notice: '좋아요를 표시했습니다.')
    else
      redirect_back(fallback_location: root_path, alert: @like.errors.full_messages.to_sentence)
    end
  end

  def destroy
    # 만약 좋아요 레코드의 id가 있다면 해당 id로 찾고, 없으면 파라미터로 대상 객체를 찾아서 좋아요 레코드를 찾습니다.
    if params[:id].present?
      @like = current_user.likes.find(params[:id])
    else
      likeable = params[:likeable_type].constantize.find(params[:likeable_id])
      @like = current_user.likes.find_by(likeable: likeable)
    end

    if @like&.destroy
      redirect_back(fallback_location: root_path, notice: '좋아요를 취소했습니다.')
    else
      redirect_back(fallback_location: root_path, alert: '좋아요 취소에 실패했습니다.')
    end
  end

  private

  def check_guest
    if current_user.email == "guest@example.com"
      # 이전 페이지로 리다이렉트 (HTTP_REFERER가 없는 경우 fallback으로 root_path 사용)
      redirect_back fallback_location: root_path, alert: "게스트 유저는 이 기능을 사용할 수 없습니다." and return
    end
  end
end
