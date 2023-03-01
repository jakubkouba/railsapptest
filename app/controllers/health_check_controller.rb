class HealthCheckController < ApplicationController
  def show
    render json: { tatus: 'GOOD' }
  end

  def edit
    render
    end
end
