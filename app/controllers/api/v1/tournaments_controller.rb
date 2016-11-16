module Api
  module V1
    class TournamentsController < BaseController
      before_action :authenticate_user

      def index
        @tournaments = Tournament.all
        render json: TournamentsRepresenter.new(@tournaments).with_all
      end

      def create
        @tournament = Tournament.new(tournament_params)
        @tournament.save!
        render json: TournamentRepresenter.new(@tournament).with_all
      end

      def update
        authorize tournament
        tournament.update_attributes!(permitted_attributes(tournament))
        render json: TournamentRepresenter.new(tournament).with_all
      end

      def destroy
        if tournament.state == "ended" || tournament.state == "started"
          render json: { errors: "Tournament already started or ended"}, status: 422
        else
          authorize tournament
          tournament.destroy!
          render json: {}, status: :no_content
        end
      end

      private

      def tournament
        @tournament ||= Tournament.includes(:game, teams: [:users]).find(params[:id])
      end

      def tournament_params
        params.require(:tournament).permit(:title, :game_id, :description, :picture, :start_date,
                                           :teams_quantity, :players_in_team, :style, :creator_id)
      end
    end
  end
end
