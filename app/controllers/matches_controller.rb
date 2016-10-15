class MatchesController < ApplicationController
  before_action :load_users, only: [:new, :create]

  def index
    @matches = Match.includes(:game, :home_team, :invited_team).all
  end

  def show
    match
  end

  def new
    @match = Match.new
    @match.build_home_team
    @match.build_invited_team
  end

  def create
    @match = Match.new(match_params)
    @match.home_team.assign_users_to_team(params[:match][:home_team_attributes][:user_ids])
    @match.invited_team.assign_users_to_team(params[:match][:invited_team_attributes][:user_ids])
    if @match.save
      flash[:notice] = 'Match created sucessfully'
      redirect_to @match
    else
      flash.now[:alert] = "#{@match.errors.full_messages.join(', ')}"
      render :new
    end
  end

  def edit
  end

  def update
    if match.can_be_played?
      if match.update_attributes(match_params)
        flash[:notice] = 'Match edited sucessfully'
        redirect_to match
        MatchWorker.perform_in(1.minute, match.round.tournament_id) if match.round_id > 0
      else
        flash.now[:alert] = "#{@match.errors.full_messages.join(', ')}"
        render :edit
      end
    else
      flash[:alert] = 'Previous round not finished yet'
      redirect_to match
    end
  end

  def destroy
    if match.destroy
      flash[:notice] = 'Match deleted sucessfully'
      redirect_to matches_path
    else
      flash[:alert] = 'Something went wrong'
      redirect_to matches_path
    end
  end

  private

  def load_users
    @users ||= User.all
  end

  def match
    @match ||= Match.includes(:game, :home_team, :invited_team).find(params[:id])
  end

  def match_params
    params.require(:match).permit(:name, :status, :game_id,
                                  :home_team_score, :invited_team_score,
                                  home_team_attributes: [:name, :user_ids],
                                  invited_team_attributes: [:name, :user_ids])
  end
end
