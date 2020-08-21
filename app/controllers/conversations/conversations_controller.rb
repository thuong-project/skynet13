# frozen_string_literal: true

class Conversations::ConversationsController < ApplicationController
  layout false
  before_action :set_conversation

  def show
    @messages = @conversation.messages
    render 'conversations/show'
  end

  def create_message
    @conversation.messages.create(body: params[:content], user_id: current_user.id)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_conversation
    @recipient = User.find(params[:recipient_id])
    @conversation = Conversation.get(current_user.id, params[:recipient_id])
  end

  # Only allow a list of trusted parameters through.
  def conversation_params
    params.require(:conversation).permit(:recipient_id)
  end
end
