module API
  module V1
    class StreamingController < API::V1::APIController
      include ActionController::Live

      skip_before_action :authenticate_user!
      skip_after_action :verify_authorized

      CHARACTERS = 1000
      STREAM_DELAY = 0.01 # Configuración del delay entre caracteres
      USE_SLOW_MODE = true # Si es `true`, envía letra por letra con delay. Si es `false`, envía como viene del servicio.

      def ask
        response.headers["Content-Type"] = "text/event-stream"
        response.headers["Cache-Control"] = "no-cache"
        response.headers["X-Accel-Buffering"] = "no"

        #ActionCable.server.broadcast "chat_#{params[:chat_id]}", { status: "processing" }

        begin
          Gemini::StreamingService.new(CHARACTERS) do |event, parsed, raw|
            text = event.dig('candidates', 0, 'content', 'parts', 0, 'text')
            next if text.nil?

            if USE_SLOW_MODE
              text.chars.each do |char|
                response.stream.write "#{char}"
                sleep(STREAM_DELAY)
              end
            else
              response.stream.write text
            end
          end.call
        rescue => e
          response.stream.write "data: ERROR #{e.message}\n\n"
        ensure
          response.stream.close
        end
      end
    end
  end
end
