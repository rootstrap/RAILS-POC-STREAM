# frozen_string_literal: true

class ChatgptChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chatgpt_channel"
  end
end