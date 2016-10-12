class MatchesController < ApplicationController
  before_action :match, only:[:show, :edit, :update, :destroy]

  def index
    @matches = Match.includes(:game, :home_team, :invited_team).all
  end

  def show
  end

  def new
    @match = Match.new
  end

  def create
    @match = Match.new(match_params)
    if @match.save
      flash[:notice] = 'Match created sucessfully'
      redirect_to @match
    else
      flash.now[:alert] = "Something wrong #{': ' + @match.errors.messages[:base].join()}"
      render :new
    end
  end

  def edit
  end

  def update
    if @match.can_be_played?
      if @match.update_attributes(match_params)
        flash[:notice] = 'Match edited sucessfully'
        redirect_to @match
        MatchWorker.perform_in(1.minute, @match.round.tournament_id)
      else
        flash.now[:alert] = "Something went wrong #{': ' + @match.errors.messages[:base].join()}"
        render :edit
      end
    else
      flash[:alert] = 'Previous round not finished yet'
      redirect_to @match
    end
  end

  def destroy
    if @match.destroy
      flash[:notice] = 'Match deleted sucessfully'
      redirect_to matches_path
    else
      flash[:alert] = 'Something went wrong'
      redirect_to matches_path
    end
  end

  private

  def match
    @match = Match.includes(:game, :home_team, :invited_team).find(params[:id])
  end

  def match_params
    params.require(:match).permit(:name, :status, :game_id, :home_team_id, :invited_team_id,
                                  :home_team_score, :invited_team_score)
  end
end
