class TournamentsController < ApplicationController
  before_action :set_tournament, only: [:show, :edit, :update, :destroy]

  def index
    @tournaments = Tournament.all
  end

  def show
    @teams = Team.all
    if current_user.admin? || current_user.creator?(@tournament)
      @users = User.all
    else
      @users = User.where(id: current_user.id)
    end
    @users_quantity =
      unless @tournament.players_in_team.blank?
        @tournament.players_total_quantity - @tournament.users.size
      end
  end

  def team
    @tournament = Tournament.find(params[:tournament_id])
    @team = Team.new
  end

  def join_team
    @tournament = Tournament.find(params[:tournament_id])
    team = Team.where(id: params[:team][:id]).first_or_initialize(team_params)
    users_to_team = params[:team][:user_ids]
    unless users_to_team.blank?
      users_to_team.each do |user|
        team.users << User.find(user)
      end
    end
    begin
      @tournament.add_team(team)
      team.save
      flash[:notice] = 'Team added'
    rescue => e
      flash[:alert] = "#{e}"
    end
    redirect_to @tournament
  end

  def add_user_to_team

  end

  def new
    @tournament = Tournament.new
  end

  def create
    @tournament = Tournament.new(tournament_params)
    @tournament.creator_id = current_user.id
    if @tournament.save
      flash[:notice] = 'Tournament created sucessfully'
      redirect_to @tournament
    else
      flash[:alert] = 'Something wrong'
      render :new
    end
  end

  def edit
    if @tournament.state == 'ended' || !current_user.creator?(@tournament)
      flash[:alert] = 'You are not creator of tournament or tournament ended'
      redirect_to tournaments_path
    end
  end

  def update
    if @tournament.update_attributes(tournament_params)
      flash[:notice] = 'Tournament edited sucessfully'
      redirect_to @tournament
    else
      flash.now[:alert] = "Something went wrong"
      render :edit
    end
  end

  def destroy
    if @tournament.state == 'ended' || @tournament.state == 'started'
      flash[:alert] = 'Tournament started or ended'
    elsif !current_user.admin? && !current_user.creator?(@tournament)
      flash[:alert] = 'You are not creator'
    else
      @tournament.destroy
      flash[:notice] = 'Tournament deleted sucessfully'
    end
    redirect_to tournaments_path
  end

  private

  def set_tournament
    @tournament = Tournament.find(params[:id])
  end

  def tournament_params
    params.require(:tournament).permit(:title, :game_id, :description, :picture, :start_date,
                                       :teams_quantity, :players_in_team, :style)
  end

  def team_params
    params.require(:team).permit(:name, :user_ids)
  end
end
