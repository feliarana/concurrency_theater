class PerformanceChannel < ApplicationCable::Channel
  def subscribed
    performance_id = params[:performance_id]
    stream_from "performance_#{performance_id}" if performance_id.present?
  end

  def unsubscribed
    # Cleanup when channel is unsubscribed
  end
end
