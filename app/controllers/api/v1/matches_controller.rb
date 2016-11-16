module Api
  module V1
    class MatchesController < BaseController
      before_action :authenticate_user

      def index
        @matches = Match.includes(:game, :home_team, :invited_team).all
        render json: MatchesRepresenter.new(@matches).with_teams
      end

      def create
        @match = Match.new(match_params)
        @match.creator_id = current_user.id
        @match.home_team.assign_users_to_team(params[:match][:home_team_attributes][:user_ids])
        @match.invited_team.assign_users_to_team(params[:match][:invited_team_attributes][:user_ids])
        @match.save!
        render json: MatchRepresenter.new(@match).with_teams
      end

      def update
        authorize match
        if match.can_be_played?
          match.update_attributes!(match_params)
          render json: MatchRepresenter.new(match).with_teams
          MatchWorker.perform_in(1.minute, match.round.tournament_id) if match.round_id > 0
        else
          render json: { errors: "Previous round not finished yet" }, status: 422
        end
      end

      def destroy
        match.destroy
        render json: {}, status: :no_content
      end

      private

      def match
        @match ||= Match.includes(:game, :home_team, :invited_team).find(params[:id])
      end

      def match_params
        params.require(:match).permit(:status, :game_id,
                                      :home_team_score, :invited_team_score,
                                      home_team_attributes: [:name, :user_ids],
                                      invited_team_attributes: [:name, :user_ids])
      end
    end
  end
end
