module Api
  module V1
    class TeamsController < BaseController
      before_action :authenticate_user

      def create
        new_team = tournament.teams.build(team_params)
        new_team.assign_users_to_team(params[:team][:user_ids])
        authorize new_team
        new_team.save!
        render json: TeamRepresenter.new(new_team).with_users
      end

      def update
        team.assign_users_to_team(params[:team][:user_ids])
        authorize team if params[:team][:user_ids].join.to_i != current_user.id
        team.update!(team_params)
        render json: TeamRepresenter.new(team).with_users
      end

      def destroy
        authorize team
        user_ids = team.team_users.select(:user_id)
        tournament.tournament_users.where(user_id: user_ids).delete_all
        team.destroy!
        render json: {}, status: :no_content
      end

      def remove_user
        user = User.find(params[:user_id])
        team = Team.find(params[:team_id])
        authorize team if current_user != user
        team.users.delete(user)
        tournament.users.delete(user)
        if team.users.size.zero?
          team.destroy!
        end
        render json: {}, status: :no_content
      end

      private

      def team
        @team ||= Team.includes(:users).find(params[:id])
      end

      def tournament
        @tournament ||= Tournament.find(params[:tournament_id])
      end

      def team_params
        params.require(:team).permit(:name, :user_ids)
      end
    end
  end
end
