module Api
  module V1
    class TeamsController < BaseController
      def create
        begin
          Team.transaction do
            @team = tournament.teams.build(team_params)
            team.assign_users_to_team(params[:team][:user_ids])
            team.save!
          end
        end
        render json: TeamRepresenter.new(@team).with_users
      end

      def update
        begin
          Team.transaction do
            team.assign_users_to_team(params[:team][:user_ids].split(", "))
          end
        end
        render json: TeamRepresenter.new(team).with_users
      end

      def destroy
        begin
          team.users.each do |user|
            tournament.users.delete(user)
          end
        end
        team.destroy!
        render json: {}, status: :no_content
      end

      def remove_user
        user = User.find(params[:user_id])
        team = Team.find(params[:team_id])
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
