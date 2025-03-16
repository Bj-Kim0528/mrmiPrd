class CardCollectionCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_card_collection
  before_action :set_card_collection_comment, only: [:destroy]

  def create
    @card_collection_comment = @card_collection.card_collection_comments.build(card_collection_comment_params)
    @card_collection_comment.user = current_user

    if @card_collection_comment.save
      redirect_to card_collection_path(@card_collection), notice: "댓글이 성공적으로 작성되었습니다."
    else
      redirect_to card_collection_path(@card_collection), alert: @card_collection_comment.errors.full_messages.to_sentence
    end
  end

  # 소프트 딜리트 방식: destroy 대신 삭제 액션에서 데이터는 삭제하지 않고, 업데이트합니다.
  def destroy
    if @card_collection_comment.update(deleted: true)
      redirect_to card_collection_path(@card_collection), notice: "댓글이 삭제되었습니다."
    else
      redirect_to card_collection_path(@card_collection), alert: "댓글 삭제에 실패했습니다."
    end
  end

  private

  def set_card_collection
    @card_collection = CardCollection.find(params[:card_collection_id])
  end

  def set_card_collection_comment
    @card_collection_comment = @card_collection.card_collection_comments.find(params[:id])
  end

  def card_collection_comment_params
    params.require(:card_collection_comment).permit(:comment)
  end
end
