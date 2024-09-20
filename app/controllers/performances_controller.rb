class PerformancesController < ApplicationController
  before_action :set_performance, only: %i[ show update destroy ]

  # GET /performances
  def index
    @performances = Performance.all

    render json: @performances
  end

  # GET /performances/1
  def show
    render json: @performance
  end

  # POST /performances
  def create
    @performance = Performance.new(performance_params)

    if @performance.save
      render json: @performance, status: :created, location: @performance
    else
      render json: @performance.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /performances/1
  def update
    if @performance.update(performance_params)
      render json: @performance
    else
      render json: @performance.errors, status: :unprocessable_entity
    end
  end

  # DELETE /performances/1
  def destroy
    @performance.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_performance
      @performance = Performance.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def performance_params
      params.require(:performance).permit(:title, :date, :tickets_available)
    end
end
