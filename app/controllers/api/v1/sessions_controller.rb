module Api
  module V1
    class SessionsController < ApplicationController
      def new
        if current_user
          flash[:notice] = 'You are already logged in'
          redirect_to matches_path
        end
      end

      def create
        @user = User.find_by_email(params[:email])
        if @user && @user.authenticate(params[:password])
          session[:user_id] = @user.id
          flash[:notice] = 'You are logged in!'
          redirect_to matches_path
        else
          flash.now[:alert] = 'Email or password incorrect'
          render :new
        end
      end

      def destroy
        session.delete(:user_id)
        flash[:notice] = 'You are logged out!'
        redirect_to log_in_path
      end
    end
  end
end
