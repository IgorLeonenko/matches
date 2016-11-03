class TeamsRepresenter
  def initialize(teams)
    @teams = teams
  end

  def basic
    @teams.map { |team| TeamRepresenter.new(team).basic }
  end

  def with_users
    @teams.map { |team| TeamRepresenter.new(team).with_users}
  end
end
