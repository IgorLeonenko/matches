module Api
  module V1
    class UsersController < BaseController
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
