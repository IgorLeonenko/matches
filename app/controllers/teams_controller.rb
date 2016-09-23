class TeamsController < ApplicationController
  before_action :set_users, only: [:new, :create]

  def index
    @teams = Team.all
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    users_to_team = params[:team][:user_ids]
    unless users_to_team.blank?
      users_to_team.each do |i|
        @team.users << User.find(i)
      end
    end
    if @team.save
      redirect_to teams_path
    else
      render :new
    end
  end

  private

  def set_users
    @users = User.all
  end

  def team_params
    params.require(:team).permit(:name)
  end

end
