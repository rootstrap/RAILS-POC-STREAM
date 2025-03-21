module API
    module V1
      class StreamingWebsocketController < API::V1::APIController
        skip_before_action :authenticate_user!
        skip_after_action :verify_authorized
  
        CHARACTERS = 1000
  
        def ask
          chat_id = params[:chat_id]
          ::Gemini::StreamingWebSocketService.new(question, chat_id).call
          render json: { message: "Processing started for chat #{chat_id}" }
        rescue => e
          render json: { error: e.message }, status: :unprocessable_entity
        end
      end
    end
  end
  