class TeamsRepresenter
  def initialize(teams)
    @teams = teams
  end

  def as_json(_ = {})
    @teams.map do |team|
      {
        id: team.id,
        name: team.name,
        users: UsersRepresenter.new(team.users)
      }
    end
  end
end