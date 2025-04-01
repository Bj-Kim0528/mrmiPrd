# app/controllers/admin/card_collection_comments_controller.rb
class Admin::CardCollectionCommentsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!  # 관리자인지 확인 (예: 별도 메서드 구현)
  before_action :set_user

  def index
    # 해당 유저의 모든 코멘트를 조회 (필요에 따라 정렬 조건 추가)
    @comments = @user.card_collection_comments.order(created_at: :desc)
    @replycomments = @user.card_collection_replies.order(created_at: :desc)
  end

  def comment_destroy
    @comment = @user.card_collection_comments.find(params[:id])
    # 실제로 데이터베이스에서 삭제하는 대신, deleted 칼럼을 true로 설정
    if @comment.update(deleted: true)
      redirect_to admin_user_card_collection_comments_path(@user), notice: "코멘트가 삭제되었습니다."
    else
      redirect_to admin_user_card_collection_comments_path(@user), alert: "코멘트 삭제에 실패했습니다."
    end
  end

  def comment_restoration
    @comment = @user.card_collection_comments.find(params[:id])
    # 실제로 데이터베이스에서 삭제하는 대신, deleted 칼럼을 true로 설정
    if @comment.update(deleted: false)
      redirect_to admin_user_card_collection_comments_path(@user), notice: "코멘트가 복구되었습니다."
    else
      redirect_to admin_user_card_collection_comments_path(@user), alert: "코멘트 복구에 실패했습니다."
    end
  end

  def reply_destroy
    @replycomments = @user.card_collection_replies.find(params[:id])
    # 실제로 데이터베이스에서 삭제하는 대신, deleted 칼럼을 true로 설정
    if @replycomments.update(deleted: true)
      redirect_to admin_user_card_collection_comments_path(@user), notice: "코멘트가 삭제되었습니다."
    else
      redirect_to admin_user_card_collection_comments_path(@user), alert: "코멘트 삭제에 실패했습니다."
    end
  end

  def reply_restoration
    @replycomments = @user.card_collection_replies.find(params[:id])
    # 실제로 데이터베이스에서 삭제하는 대신, deleted 칼럼을 true로 설정
    if @replycomments.update(deleted: false)
      redirect_to admin_user_card_collection_comments_path(@user), notice: "코멘트가 복구되었습니다."
    else
      redirect_to admin_user_card_collection_comments_path(@user), alert: "코멘트 복구에 실패했습니다."
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  # 필요에 따라 strong parameters 추가 (여기서는 destroy만 사용하므로 별도 파라미터는 필요없음)
end
