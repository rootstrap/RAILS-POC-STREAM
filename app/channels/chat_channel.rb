class ChatChannel < ApplicationCable::Channel
    def subscribed
      # Conectamos el canal a un stream, en este caso, a un chat específico por ID
      stream_from "chat_#{params[:chat_id]}"
    end
  
    def unsubscribed
      # Código para limpiar cuando el usuario se desconecte
    end
  
    def ask_question(data)
      # Aquí se procesará la pregunta que el cliente envíe
      question = data['question']
      
      # Llamamos al servicio de Gemini para obtener la respuesta en streaming
      service = Gemini::SimpleService.new(question)
  
      service.call do |event, parsed, raw|
        # Transmitimos el evento al cliente en tiempo real a través de WebSocket
        ActionCable.server.broadcast "chat_#{params[:chat_id]}", event
      end
    end
  end
  