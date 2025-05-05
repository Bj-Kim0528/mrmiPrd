class ChatChannel < ApplicationCable::Channel
  def subscribed
    conv = Conversation.find(params[:conversation_id])
    stream_for conv
  end
end

