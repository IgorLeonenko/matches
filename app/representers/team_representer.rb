class TeamRepresenter
  def initialize(team)
    @team = team
  end

  def basic
    {
      id: @team.id,
      name: @team.name,
    }
  end

  def with_users
    basic.merge(
      users: UsersRepresenter.new(@team.users).basic,
    )
  end
end
