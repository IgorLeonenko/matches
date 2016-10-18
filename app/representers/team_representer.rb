class TeamRepresenter
  def initialize(team)
    @team = team
  end

  def as_json(_ = {})
    {
      id: @team.id,
      name: @team.name,
      users: UsersRepresenter.new(@team.users)
    }
  end
end