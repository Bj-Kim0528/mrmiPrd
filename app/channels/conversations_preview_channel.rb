class ConversationsPreviewChannel < ApplicationCable::Channel
  def subscribed
    # 사용자별 스트림
    stream_for current_user
  end
end
