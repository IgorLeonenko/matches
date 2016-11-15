class TournamentPolicy < ApplicationPolicy
  attr_reader :tournament

  def initialize(user, tournament)
    @user = user
    @tournament = tournament
  end

  def update?
    user.creator?(tournament.id) || user.admin?
  end

  def destroy?
    user.creator?(tournament.id) || user.admin?
  end

  def permitted_attributes
    if tournament.state == "started"
      [:title, :description, :picture]
    elsif tournament.state == "ended"
      []
    else
      [:title, :game_id, :description, :picture, :start_date,
       :teams_quantity, :players_in_team, :style, :creator_id]
    end
  end
end
