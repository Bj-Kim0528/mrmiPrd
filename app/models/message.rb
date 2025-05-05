# app/models/message.rb
class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  validates :content, presence: true

  # 실시간 채팅창 브로드캐스트
  after_create_commit :broadcast_message

  # 인덱스 미리보기 갱신
  after_create_commit :broadcast_preview_update

  # 첫 메시지라면 대화 목록에 prepend
  after_create_commit :broadcast_first_message, if: -> { conversation.messages.count == 1 }

  private

  def broadcast_message
    ChatChannel.broadcast_to(conversation, render_message)
  end

  def broadcast_preview_update
    conversation.users.each do |participant|
      ConversationsPreviewChannel.broadcast_to(
        participant,
        id:   ActionView::RecordIdentifier.dom_id(conversation),
        html: ApplicationController.renderer.render(
          partial: "conversations/conversation_preview",
          locals: { conversation: conversation, viewer: participant }
        )
      )
    end
  end

  def broadcast_first_message
    conversation.users.each do |participant|
      Turbo::StreamsChannel.broadcast_prepend_to(
        participant,
        target: "conversations_#{participant.id}",               # ul#conversations_#{user.id}
        partial: "conversations/conversation_preview",
        locals: { conversation: conversation, viewer: participant }
      )
    end
  end

  def render_message
    ApplicationController.renderer.render(
      partial: 'messages/message',
      locals:  { message: self }
    )
  end
end
