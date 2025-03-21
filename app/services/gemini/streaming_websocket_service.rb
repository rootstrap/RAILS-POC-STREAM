# frozen_string_literal: true

module Gemini
    class StreamingWebsocketService
      def initialize(question, chat_id)
        @question = question
        @chat_id = chat_id
      end
  
      def call
        client.stream_generate_content(generate_content_params, server_sent_events: true) do |event, _, _|
          text = event.dig('candidates', 0, 'content', 'parts', 0, 'text')
          next if text.nil?
  
          ActionCable.server.broadcast("chat_#{@chat_id}", { text: text })
        end
      rescue Faraday::TooManyRequestsError
        ActionCable.server.broadcast("chat_#{@chat_id}", { error: "Too many requests" })
      rescue StandardError => e
        ActionCable.server.broadcast("chat_#{@chat_id}", { error: e.message })
      end
  
      private
  
      def client
        @client ||= Gemini.new(
          credentials: {
            service: 'generative-language-api',
            api_key: 'AIzaSyDjLw-ZaRIWvZdIciOJklLmd09JKwOkBoM'
          },
          options: { model: 'gemini-1.5-flash', server_sent_events: true }
        )
      end
  
      def generate_content_params
        {
          contents: [
            {
              role: 'user',
              parts: [
                { text: @question }
              ]
            }
          ]
        }
      end
    end
  end
  