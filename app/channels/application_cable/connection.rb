module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :performance_id

    def connect
      self.performance_id = request.params[:performance_id]
    end
  end
end
