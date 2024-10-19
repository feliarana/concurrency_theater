class TicketsController < ApplicationController
  before_action :set_ticket, only: [ :reserve, :purchase, :cancel ]
  after_action :broadcast_ticket_update, only: [ :reserve, :purchase, :cancel ]
  after_action :broadcast_reset, only: [ :reset ]

  def index
    Rails.logger.info("[TicketsController#index] Starting ticket listing process !")

    @tickets = Ticket.all
    # TODO: this will refresh the status of reserved tickets that havent finished the purchase
    @tickets.each(&:reserved?)
    render json: @tickets
  end

  def user_tickets
    @tickets = Ticket.includes(:user, :performance).where(user_id: current_user.id)
    render json: @tickets.as_json(
      include: {
        user: { only: [:id, :name] },
        performance: { only: [:id, :title] }
    }
  )
  end

  def reserve
    handle_ticket(:available?, :reserved)
  end

  def purchase
    return render_ticket_error(:purchased) unless @ticket.reserved?

    handle_ticket(:can_be_purchased?, :purchased)
  end

  def cancel
    handle_ticket(:can_be_cancelled?, :available)
  end

  def reset
    Ticket.update_all(status: "available", reserved_at: nil, reserved_until: nil, user_id: nil)
    broadcast_reset
    head :no_content
  end

  private

  def handle_ticket(status_method, new_status)
    Rails.logger.info("[TicketsController#handle_ticket] Processing ticket ##{@ticket.id} - Status change: #{new_status}") if @ticket.present?

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
    return unless @ticket

    ActionCable.server.broadcast("performance_#{@ticket.performance.id}", {
      action: action_name,
      ticket: @ticket
    })
  end

  def broadcast_reset
    tickets = Ticket.all
    return if tickets.empty?

    tickets.each{ |t| 
      ActionCable.server.broadcast("performance_#{t.performance.id}", {
        action: "reset",
        tickets: tickets
      })
    }
  end
end
