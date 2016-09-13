class MatchesController < ApplicationController
  before_action :match, only:[:show, :edit, :update, :destroy]

  def index
    @matches = Match.all
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
      redirect_to matches_path
    else
      flash.now[:alert] = 'Something wrong'
      render :new
    end
  end

  def edit
  end

  def update
    if @match.update_attributes(match_params)
      flash[:notice] = 'Match edited sucessfully'
      redirect_to matches_path
    else
      flash.now[:alert] = 'Something went wrong'
      render :edit
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
      @match = Match.find(params[:id])
    end

    def match_params
      params.require(:match).permit(:name, :status)
    end
end
