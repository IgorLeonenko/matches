class TeamPolicy < ApplicationPolicy
  attr_reader :team

  def initialize(user, team)
    @user = user
    @team = team

  end

  def create?
    user.creator?(team.tournament_id)
  end

  def update?
    user.creator?(team.tournament_id)
  end

  def destroy?
    user.creator?(team.tournament_id)
  end

  def remove_user?
    user.creator?(team.tournament_id)
  end
end
