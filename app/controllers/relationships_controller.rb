class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    # 팔로우할 사용자 ID는 파라미터로 전달된 followed_id를 사용합니다.
    user = User.find(params[:followed_id])
    current_user.active_relationships.create(followed: user)
    redirect_back fallback_location: root_path, notice: "팔로우 했습니다."
  end

  def destroy
    # 언팔로우할 관계는 파라미터로 전달된 id를 사용하거나 followed_id로 조회할 수 있습니다.
    relationship = current_user.active_relationships.find(params[:id])
    relationship.destroy
    redirect_back fallback_location: root_path, notice: "언팔로우 했습니다."
  end
end

