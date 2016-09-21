class TournamentsController < ApplicationController
  before_action :set_tournament, only: [:show, :edit, :update, :destroy]

  def index
    @tournaments = Tournament.all
  end

  def show
    @team = Team.new
  end

  def new
    @tournament = Tournament.new
  end

  def create
    @tournament = Tournament.new(tournament_params)
    @tournament.creator_id = current_user.id
    if @tournament.save
      flash[:notice] = 'Tournament created sucessfully'
      redirect_to tournaments_path
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
    else
      @tournament.destroy
      flash[:notice] = 'Match deleted sucessfully'
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
end
