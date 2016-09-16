class UsersController < ApplicationController
  skip_before_action :authorize

  def new
    if current_user
      flash[:notice] = 'You are already logged in'
      redirect_to matches_path
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = 'User create sucessfully'
      redirect_to matches_path
    else
      flash[:alert] = 'Something wrong'
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :avatar, :username,
                                 :password, :password_confirmation)
  end
end
