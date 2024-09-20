class TicketsController < ApplicationController
  before_action :set_ticket, only: [ :reserve, :purchase, :cancel ]
  after_action :broadcast_ticket_update, only: [ :reserve, :purchase, :cancel ]

  def index
    @tickets = Ticket.all
    @tickets.each(&:reserved?)
    render json: @tickets
  end

  def reserve
    handle_ticket(:available?, :reserved)
  end

  def purchase
    handle_ticket(:can_be_purchased?, :purchased)
  end

  def cancel
    handle_ticket(:can_be_cancelled?, :available)
  end

  private

  def handle_ticket(status_method, new_status)
    Ticket.transaction do
      if @ticket.send(status_method, user_id: current_user.id)
        @ticket.update!(status: new_status.to_s, user_id: current_user.id)
        render json: @ticket, status: :created
      else
        render json: { error: "Ticket cannot be #{new_status}. Status: #{@ticket.status}. First reserve, then purchase (with the same user)" }, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def set_ticket
    id = params[:id] || params[:ticket_id]
    @ticket = Ticket.lock.find(id)
  end

  def broadcast_ticket_update
    ActionCable.server.broadcast("tickets_#{params[:performance_id]}", @ticket) if @ticket
  end
end
