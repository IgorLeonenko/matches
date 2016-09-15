class SessionsController < ApplicationController
  skip_before_action :authorization

  def new
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = 'You are log in!'
      redirect_to matches_path
    else
      flash.now[:alert] = 'Name or password incorrect'
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:notice] = 'You are log out!'
    redirect_to root_path
  end
end