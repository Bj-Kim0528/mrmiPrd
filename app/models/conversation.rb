class Conversation < ApplicationRecord
  has_many :conversation_memberships, dependent: :destroy
  has_many :users, through: :conversation_memberships
  has_many :messages, dependent: :destroy

  # 두 사용자 간 채팅방 조회 또는 생성
  def self.find_or_create_between(u1, u2)
    conv = joins(:conversation_memberships)
           .where(conversation_memberships: { user_id: [u1.id, u2.id] })
           .group('conversations.id')
           .having('COUNT(*) = 2')
           .first
    conv || create.tap { |c| c.users << [u1, u2] }
  end
end