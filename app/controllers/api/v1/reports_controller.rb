class Api::V1::ReportsController < ApplicationController
  def index
    service = Reports::Fetcher.call

    if service.success?
      render json: service.reports, status: :ok
    else
      render json: { message: service.message }, status: :unprocessable_entity
    end
  end
end
