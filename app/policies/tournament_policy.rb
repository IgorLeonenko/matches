class TournamentPolicy < ApplicationPolicy
  attr_reader :tournament

  def initialize(user, tournament)
    @user = user
    @tournament = tournament
  end

  def update
    user.creator?(tournament.id)
  end
end
