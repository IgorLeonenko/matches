class MatchPolicy < ApplicationPolicy
  attr_reader :match

  def initialize(user, match)
    @user = user
    @match = match
  end

  def update?
    match.home_team.users.include?(user) || match.invited_team.users.include?(user)
  end
end
