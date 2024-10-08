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
    return render_ticket_error(:purchased) if !@ticket.reserved?

    handle_ticket(:can_be_purchased?, :purchased)
  end


  def cancel
    handle_ticket(:can_be_cancelled?, :available)
  end

  def reset
    Ticket.update_all(status: "available", reserved_at: nil, reserved_until: nil, user_id: nil)
  end

  private

  def handle_ticket(status_method, new_status)
    Ticket.transaction do
      if ticket_eligible?(status_method)
        update_ticket_status(new_status)
        render json: @ticket, status: :created
      else
        render_ticket_error(new_status)
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def ticket_eligible?(status_method)
    @ticket.send(status_method, user_id: current_user.id)
  end

  def update_ticket_status(new_status)
    update_attributes = { status: new_status.to_s, user_id: current_user.id }

    if new_status == :reserved
      update_attributes.merge!(reserved_at: Time.zone.now, reserved_until: Time.zone.now + reservation_duration)
    elsif new_status == :available
      update_attributes.merge!(reserved_at: nil, reserved_until: nil, user_id: nil)
    end

    @ticket.update!(update_attributes)
  end

  def render_ticket_error(new_status)
    render json: { error: "Ticket cannot be #{new_status}. Status: #{@ticket.status}. First reserve, then purchase (with the same user)" }, status: :unprocessable_entity
  end

  def reservation_duration
    10.minutes
  end

  def set_ticket
    id = params[:id] || params[:ticket_id]
    @ticket = Ticket.lock.find(id)
  end

  def broadcast_ticket_update
    ActionCable.server.broadcast("tickets_#{params[:performance_id]}", @ticket) if @ticket
  end
end
