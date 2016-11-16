class MatchPolicy < ApplicationPolicy
  attr_reader :match

  def initialize(user, match)
    @user = user
    @match = match
  end

  def update?
    player_in_match? || admin_or_creator?
  end

  private

  def player_in_match?
    match.home_team.users.include?(user) || match.invited_team.users.include?(user)
  end

  def admin_or_creator?
    user.admin? || user.creator?(match.round.tournament.id)
  end
end
