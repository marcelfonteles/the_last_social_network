module Api
  module V1
    class TradesController < ApplicationController

      def create
        service = Trades::Creator.call(params: trade_params)

        if service.success?
          render json: { message: 'Transaction successful.' }, status: :ok
        else
          render json: { message: service.message }, status: :unprocessable_entity
        end
      end

      private

      def trade_params
        params
          .require(:trade)
          .permit(
            user_trader_1: [:id, send: [:water, :food, :medicine, :ammo] ],
            user_trader_2: [:id, send: [:water, :food, :medicine, :ammo]]
          )
      end
    end
  end
end
