module Api
  module V1
    class UsersController < ApplicationController
      before_action :find_user, only: %w[show update]

      def index
        users = User.all.paginate(params[:page], params[:hits_per_page])
        render json: users, status: :ok
      end

      def show
        render json: @user, status: :ok
      end

      def create
        user = User.new(user_params)
        if user.save
          render json: user, status: :ok
        else
          render json: user.errors, status: :unprocessable_entity
        end
      end

      def update
        if @user.update(user_params)
          render json: @user, status: :ok
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :birthday, :gender, :last_latitude, :last_longitude)
      end

      def find_user
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { message: 'User not found.' }, status: :unprocessable_entity
      end
    end
  end
end