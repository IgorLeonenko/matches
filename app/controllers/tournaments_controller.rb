class TournamentsController < ApplicationController
  before_action :set_tournament, only: [:show, :edit, :update, :destroy]

  def index
    @tournaments = Tournament.all
  end

  def show
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

  def add_user
    @tournament = Tournament.find(params[:tournament_id])
    begin
      User.find(params[:user][:username])
      begin
        @tournament.users << User.find(params[:user][:username])
        flash[:notice] = 'User added to tournament'
      rescue ActiveRecord::RecordInvalid
        flash[:alert] = 'User already in tournament'
      end
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = 'User not found'
    end
    redirect_to @tournament
  end

  def remove_user
    @tournament = Tournament.find(params[:tournament_id])
    user = User.find(params[:user_id])
    if user == current_user || current_user.admin?
      @tournament.users.delete(user)
      flash[:notice] = 'User removed from tournament'
    else
      flash[:alert] = 'You cant remove other users from tournament'
    end
    redirect_to @tournament
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
end
