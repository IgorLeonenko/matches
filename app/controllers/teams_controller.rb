class TeamsController < ApplicationController

  def new
    @team = tournament.teams.build
  end

  def create
    Team.transaction do
      @team = tournament.teams.build(team_params)
      begin
        team.assign_users_to_team(params[:team][:user_ids])
        team.save!
      rescue => @e
        @team_error = true
        raise ActiveRecord::Rollback
      end
    end

    if @team_error == true
      flash.now[:alert] = "#{@e}"
      render :new
    else
      flash[:notice] = 'Team added'
      redirect_to tournament
    end
  end

  def update
    team.transaction do
      begin
        team.assign_users_to_team(params[:team][:user_ids].split(','))
        flash[:notice] = 'User added'
      rescue => e
        flash[:alert] = "#{e}"
        raise ActiveRecord::Rollback
      end
    end
    redirect_to tournament
  end

  private

  def team
    @team ||= Team.find(params[:id])
  end

  def tournament
    @tournament ||= Tournament.find(params[:tournament_id])
  end

  def team_params
    params.require(:team).permit(:name, :user_ids)
  end

end
