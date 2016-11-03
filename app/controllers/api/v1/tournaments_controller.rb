module Api
  module V1
    class TournamentsController < ApplicationController

      def index
        @tournaments = Tournament.all
        render json: TournamentsRepresenter.new(@tournaments).with_teams_and_users
      end

      def show
        render json: TournamentRepresenter.new(tournament).with_teams_and_users
      end

      def new
        @tournament = Tournament.new
      end

      def create
        @tournament = Tournament.new(tournament_params)
        @tournament.creator_id = current_user.id
        if @tournament.save
          flash[:notice] = "Tournament created sucessfully"
          redirect_to tournament
        else
          flash.now[:alert] = "#{@tournament.errors.full_messages.join(", ")}"
          render :new
        end
      end

      def edit
        if tournament.state == "ended" || !current_user.creator?(tournament)
          flash[:alert] = "You are not creator of tournament or tournament ended"
          redirect_to tournaments_path
        end
      end

      def update
        if tournament.update_attributes(tournament_params)
          flash[:notice] = "Tournament edited sucessfully"
          redirect_to @tournament
        else
          flash.now[:alert] = "Something went wrong"
          render :edit
        end
      end

      def destroy
        if tournament.state == "ended" || tournament.state == "started"
          flash[:alert] = "Tournament started or ended"
        elsif !current_user.admin? && !current_user.creator?(tournament)
          flash[:alert] = "You are not creator"
        else
          tournament.destroy
          flash[:notice] = "Tournament deleted sucessfully"
        end
        redirect_to tournaments_path
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
