module ApplicationCable
  class Connection < ActionCable::Connection::Base
    def connect
      Rails.logger.info "🔌 WebSocket connection established (Anonymous)"
    end
  end
end
