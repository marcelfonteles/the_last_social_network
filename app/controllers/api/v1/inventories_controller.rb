module Api
  module V1
    class InventoriesController < ApplicationController
      before_action :find_user
      before_action :find_inventory

      def update
        if @inventory.update(inventory_params)
          render json: @inventory, status: :ok
        else
          render json: @inventory.errors, status: :unprocessable_entity
        end
      end

      private

      def find_user
        @user = User.find(params[:user_id])
      rescue ActiveRecord::RecordNotFound
        render json: { message: 'User not found.' }, status: :unprocessable_entity
      end

      def find_inventory
        @inventory = Inventory
                       .where(user_id: @user.id)
                       .find_by!(find_inventory_params)
      rescue ActiveRecord::RecordNotFound
        render json: { message: 'Inventory not found.' }, status: :unprocessable_entity
      end

      def find_inventory_params
        params.require(:inventory).permit(:item)
      end

      def inventory_params
        params.require(:inventory).permit(:item, :quantity)
      end
    end
  end
end
