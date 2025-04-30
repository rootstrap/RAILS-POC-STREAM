module Gemini
  class StreamingService
    class TooManyRequestsError < StandardError; end
    class QuestionError < StandardError; end

    def initialize(characters, &block)
      @block = block
      @characters = characters
      @mocked = true
    end

    def call
      if @mocked
        Gemini::StreamingMockedServiceSse.new(@characters, &@block).call
      else
        client.stream_generate_content(generate_content_params, server_sent_events: true) do |event, parsed, raw|
          @block.call(event, parsed, raw)
        end
      end
    rescue Faraday::TooManyRequestsError
      raise TooManyRequestsError, 'Too many requests. Please try again later.'
    rescue StandardError => e
      raise QuestionError, "An error occurred while asking the question: #{e.message}"
    end

    private

    attr_reader :question

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
              { text: "puedes dar un cuento de #{@characters} palabras" }
            ]
          }
        ],
        safetySettings: [
          {
            category: 'HARM_CATEGORY_DANGEROUS_CONTENT',
            threshold: 'BLOCK_NONE'
          }
        ]
      }
    end
    
  end
end
