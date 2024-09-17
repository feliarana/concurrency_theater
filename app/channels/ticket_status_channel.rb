class TicketStatusChannel < ApplicationCable::Channel
  def subscribed
    stream_from "tickets_#{params[:performance_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
