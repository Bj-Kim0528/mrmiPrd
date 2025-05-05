class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation, only: [:show, :destroy]

  def index
    @conversations = current_user
      .conversations
      .joins(:conversation_memberships)
      .group("conversations.id")
      .having("COUNT(conversation_memberships.id) = 2")  # 정확히 2명 있는 방
      .includes(:users)
  end

  def show
    # set_conversation 으로 @conversation 로드
  
    # 1) 내가 대화방에 속해 있는지 체크
    unless @conversation.users.include?(current_user)
      redirect_to conversations_path, alert: "이미 나간 채팅방입니다."
      return
    end
  
    # 2) 상대가 남아 있는지 확인
    others = @conversation.users.where.not(id: current_user.id)
    if others.empty?
      @other_left = true
      flash.now[:alert] = "상대방이 채팅을 나갔습니다."
      @messages = @conversation.messages.order(:created_at)
    else
      @other_left = false
      @other    = others.first
      @messages = @conversation.messages.order(:created_at)
    end
  end

  def create
    other = User.find(params[:user_id])
    @conversation = Conversation.find_or_create_between(current_user, other)
    redirect_to @conversation
  end

  def destroy
    membership = @conversation.conversation_memberships.find_by(user: current_user)
    membership.destroy if membership
  
    # 1명만 남았다면 conversation 자체도 지우기 전, 나감 안내만 브로드캐스트
    ChatChannel.broadcast_to(
      @conversation,
      { type: 'user_left', user_name: current_user.nickname }
    )
  
    # 남은 멤버수 체크
    if @conversation.conversation_memberships.count < 2
      @conversation.destroy
    end
  
    redirect_to conversations_path, notice: "채팅방에서 나갔습니다."
  end

  private

  def set_conversation
    @conversation = Conversation.find_by(id: params[:id])

    unless @conversation
      redirect_to conversations_path, alert: "해당 채팅방이 존재하지 않습니다."
    end
  end
end
