module Api
  module V1
    class UsersController < BaseController
      before_action :authenticate_user, except: :create

      def index
        users = User.all
        render json: UsersRepresenter.new(users).basic
      end

      def create
        @user = User.new(user_params)
        @user.save!
        render json: UserRepresenter.new(@user).basic
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :avatar, :username,
                                     :password, :password_confirmation)
      end
    end
  end
end
