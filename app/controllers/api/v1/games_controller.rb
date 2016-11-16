module Api
  module V1
    class GamesController < BaseController
      before_action :authenticate_user

      def index
        games = Game.all
        render json: GamesRepresenter.new(games).basic
      end
    end
  end
end
