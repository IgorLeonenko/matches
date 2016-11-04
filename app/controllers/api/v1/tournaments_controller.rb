module Api
  module V1
    class TournamentsController < ApplicationController
      def index
        @tournaments = Tournament.all
        render json: TournamentsRepresenter.new(@tournaments).with_teams_and_users
      end

      def create
        @tournament = Tournament.new(tournament_params)
        @tournament.creator_id = current_user.id
        if @tournament.save
          render json: TournamentRepresenter.new(tournament).with_teams_and_users
        else
          render json: { errors: @tournament.errors }, status: 422
        end
      end

      def update
        if tournament.update_attributes(tournament_params)
          render json: TournamentRepresenter.new(tournament).with_teams_and_users
        else
          render json: { errors: tournament.errors }, status: 422
        end
      end

      def destroy
        if tournament.state == "ended" || tournament.state == "started"
          render json: { errors: "Tournament started or ended"}, status: 422
        elsif !current_user.admin? && !current_user.creator?(tournament)
          render json: { errors: "You are not creator" }, status: 422
        else
          tournament.destroy
          render json: {}, status: :no_content
        end
      end

      private

      def tournament
        @tournament ||= Tournament.includes(:game, teams: [:users]).find(params[:id])
      end

      def tournament_params
        params.require(:tournament).permit(:title, :game_id, :description, :picture, :start_date,
                                           :teams_quantity, :players_in_team, :style)
      end
    end
  end
end
