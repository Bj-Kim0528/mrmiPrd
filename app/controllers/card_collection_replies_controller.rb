class CardCollectionRepliesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_guest
  before_action :set_card_collection_comment
  before_action :set_card_collection_reply, only: [:destroy]

  # 답글 생성 (POST /card_collection_comments/:card_collection_comment_id/card_collection_replies)
  def create
    @card_collection_reply = @card_collection_comment.card_collection_replies.build(card_collection_reply_params)
    @card_collection_reply.user = current_user

    if @card_collection_reply.save
      redirect_to card_collection_path(@card_collection_comment.card_collection), notice: "답글이 성공적으로 작성되었습니다."
    else
      redirect_to card_collection_path(@card_collection_comment.card_collection), alert: @card_collection_reply.errors.full_messages.to_sentence
    end
  end

  # 답글 삭제 (DELETE /card_collection_comments/:card_collection_comment_id/card_collection_replies/:id)
  def destroy
    if @card_collection_reply.update(deleted: true)
      redirect_to card_collection_path(@card_collection_comment.card_collection), notice: "답글이 삭제되었습니다."
    else
      redirect_to card_collection_path(@card_collection_comment.card_collection), alert: "답글 삭제에 실패했습니다."
    end
  end

  private

  def set_card_collection_comment
    @card_collection_comment = CardCollectionComment.find(params[:card_collection_comment_id])
  end

  def set_card_collection_reply
    @card_collection_reply = @card_collection_comment.card_collection_replies.find(params[:id])
  end

  def card_collection_reply_params
    params.require(:card_collection_reply).permit(:comment, :parent_reply_id)
  end

  def check_guest
    if current_user.email == "guest@example.com"
      # 이전 페이지로 리다이렉트 (HTTP_REFERER가 없는 경우 fallback으로 root_path 사용)
      redirect_back fallback_location: root_path, alert: "게스트 유저는 이 기능을 사용할 수 없습니다." and return
    end
  end
end
