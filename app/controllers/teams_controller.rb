class TeamsController < ApplicationController
  before_action :set_users, only: [:new, :create]
  before_action :set_tournament
  before_action :set_team, only: :update

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    users_to_team = params[:team][:user_ids]
    unless users_to_team.blank?
      users_to_team.each do |user|
        @team.users << User.find(user)
      end
    end

    @team.transaction do
      begin
        @tournament.add_team!(@team)
        @team.save!
        @tournament.add_user!(@team)
        flash[:notice] = 'Team added'
      rescue => e
        @error = true
        flash.now[:alert] = "#{e}"
      end
      raise ActiveRecord::Rollback if @error
    end

    if @error
      render :new
    else
      redirect_to @tournament
    end
  end

  def update
    user = User.find(params[:team][:user_ids])
    @team.transaction do
      begin
        @team.users << user
        @tournament.add_user!(@team)
        flash[:notice] = 'User added'
      rescue => e
        @error = true
        flash[:alert] = "#{e}"
      end
      raise ActiveRecord::Rollback if @error
    end
    redirect_to @tournament
  end

  private

  def set_users
    @users = User.all
  end

  def set_team
    @team = Team.find(params[:id])
  end

  def set_tournament
    @tournament = Tournament.find(params[:tournament_id])
  end

  def team_params
    params.require(:team).permit(:name, :user_ids)
  end

end
