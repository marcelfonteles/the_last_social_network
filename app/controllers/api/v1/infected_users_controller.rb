module Api
  module V1
    class InfectedUsersController < ApplicationController
      def update
        service = InfectedUsers::Updater.call(user_id: params[:user_id])

        if service.success?
          render json: service.user, status: :ok
        else
          render json: service.message, status: :unprocessable_entity
        end
      end
    end
  end
end
