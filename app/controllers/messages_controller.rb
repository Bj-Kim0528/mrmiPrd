class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation

  def create
    @message = @conversation.messages.build(message_params.merge(user: current_user))
    if @message.save
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
    head(:forbidden) unless @conversation.users.include?(current_user)
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
