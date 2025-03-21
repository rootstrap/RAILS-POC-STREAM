# frozen_string_literal: true
require_dependency 'gemini/streaming_websocket_service'

class ChatChannel < ApplicationCable::Channel
  def subscribed
    chat_id = params[:chat_id]

    if chat_id.present?
      stream_from "chat_#{chat_id}"
      Rails.logger.info "📡 Subscribed to ChatChannel for chat_id: #{chat_id}"
      
      # ✅ Corrected: Ensure transmit takes a single argument
      transmit({ type: "confirm_subscription", chat_id: chat_id })
    else
      reject
    end
  end

  def unsubscribed
    Rails.logger.info "❌ Unsubscribed from ChatChannel"
  end

  def ask_question(data)
    chat_id = params[:chat_id]
    question = data['question']

    Rails.logger.info "📩 Received question in ChatChannel: #{question}"

    ::Gemini::StreamingWebsocketService.new(question, chat_id).call
  end
end
