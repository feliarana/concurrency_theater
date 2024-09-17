class TicketsController < ApplicationController
  after_action :broadcast_ticket_update, only: [ :create ]
  # before_action :set_ticket, only: [ :update, :destroy ]

  def index
    @tickets = Ticket.all
    render json: @tickets
  end

  # POST /tickets
  def create
    Ticket.transaction do
      @ticket = Ticket.lock.find(params[:ticket_id])

      if @ticket.available?
        @ticket.update!(status: :reserved, user_id: params[:user_id])
        render json: @ticket, status: :created
      else
        render json: { error: "Ticket not available" }, status: :unprocessable_entity
      end
    end
  end

  # def update
  #   if @ticket.update(ticket_params)
  #     render json: @ticket
  #   else
  #     render json: @ticket.errors, status: :unprocessable_entity
  #   end
  # end

  # def destroy
  #   @ticket.destroy
  # end

  private


  def broadcast_ticket_update
    return unless @ticket

    ActionCable.server.broadcast("tickets_#{params[:performance_id]}", @ticket)
  end


  # def set_ticket
  #   @ticket = Ticket.find(params[:id])
  # end

  # def ticket_params
  #   params.require(:ticket).permit(:status, :user_id)
  # end
end
