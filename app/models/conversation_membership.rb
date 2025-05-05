class ConversationMembership < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  after_destroy :cleanup_conversation

  private

  def cleanup_conversation
    # 멤버가 2명 미만이면 대화방 자체를 삭제
    if conversation.conversation_memberships.count < 2
      conversation.destroy
    end
  end
end