class TeamsController < ApplicationController

  def new
    @team = tournament.teams.build
  end

  def create
    begin
      Team.transaction do
        @team = tournament.teams.build(team_params)
        team.assign_users_to_team(params[:team][:user_ids])
        team.save!
      end
    rescue => @e
      @team_error = true
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
    begin
      Team.transaction do
        team.assign_users_to_team(params[:team][:user_ids].split(','))
      end
      flash[:notice] = 'User added'
    rescue => e
      flash[:alert] = "#{e}"
    end
    redirect_to tournament
  end

  def destroy
    begin
      team.users.each do |user|
        tournament.users.delete(user)
      end
      team.destroy
      flash[:notice] = 'Team removed from tournament'
    rescue => e
      flash[:alert] = "#{e}"
    end
    redirect_to tournament
  end

  def remove_user
    user = User.find(params[:user_id])
    team = Team.find(params[:team_id])
    team.users.delete(user)
    tournament.users.delete(user)
    if team.users.size == 0
      team.destroy
    end
    flash[:notice] = 'User removed from team'
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
