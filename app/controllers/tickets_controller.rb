class TicketsController < ApplicationController
  before_action :set_ticket, only: [ :create, :purchase, :cancel ]
  after_action :broadcast_ticket_update, only: [ :create, :purchase, :cancel ]

  def index
    @tickets = Ticket.all
    @tickets.each(&:reserved?)
    render json: @tickets
  end

  # POST /tickets/{ticket_id}/reserve
  def create
    handle_ticket(:available?, :reserved)
  end

  # POST /tickets/{ticket_id}/purchase
  def purchase
    handle_ticket(:reserved?, :purchased)
  end

  # POST /tickets/{ticket_id}/cancel
  def cancel
    handle_ticket(:can_be_cancelled?, :cancelled)
  end

  private

  def handle_ticket(status_method, new_status)
    Ticket.transaction do
      if @ticket.send(status_method)
        @ticket.update!(status: new_status, user_id: params[:user_id])
        render json: @ticket, status: :created
      else
        render json: { error: "Ticket cannot be #{new_status}" }, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def set_ticket
    @ticket = Ticket.lock.find(params[:ticket_id])
  end

  def broadcast_ticket_update
    ActionCable.server.broadcast("tickets_#{params[:performance_id]}", @ticket) if @ticket
  end
end
