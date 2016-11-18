module Api
  module V1
    class TeamsController < BaseController
      def create
        new_team = tournament.teams.build(team_params)
        new_team.assign_users_to_team(params[:team][:user_ids])
        new_team.save!
        render json: TeamRepresenter.new(new_team).with_users
      end

      def update
        team.users <<  User.find(params[:team][:user_ids])
        team.tournament.users. << User.find(params[:team][:user_ids]) if team.tournament
        render json: TeamRepresenter.new(team).with_users
      end

      def destroy
        user_ids = team.team_users.select(:user_id)
        tournament.tournament_users.where(user_id: user_ids).delete_all
        team.destroy!
        render json: TeamRepresenter.new(team).with_users
      end

      def remove_user
        user = User.find(params[:user_id])
        team = Team.find(params[:team_id])
        team.users.delete(user)
        tournament.users.delete(user)
        if team.users.size.zero?
          team.destroy!
        end
        render json: TeamRepresenter.new(team).with_users
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
