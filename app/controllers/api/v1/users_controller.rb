module Api
  module V1
    class UsersController < ApplicationController

      def create
        @user = User.new(user_params)
        if @user.save
          session[:user_id] = @user.id
          render json: UserRepresenter.new(@user).basic
        else
          render json: { errors: @user.errors }, status: 422
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :avatar, :username,
                                     :password, :password_confirmation)
      end
    end
  end
end
