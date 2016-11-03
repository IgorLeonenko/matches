class TournamentScheduler
  def initialize(tournament)
    @tournament = tournament
    @rounds = []
    @teams = tournament.teams
  end

  def start_tournament
    @tournament.update_attribute(:state, "started")

    rounds_number = Math.log2(@teams.size).ceil
    rounds_number.times do |r_number|
      @rounds << @tournament.rounds.create(number: r_number)
    end

    if (Math.log2(@teams.size) % 1).zero?
      @teams.sample(@teams.size).each_slice(2) do |team_ary|
        schedule_matches(@rounds, @tournament, team_ary)
      end
    else
      numbers = @teams.size - (2**Math.log2(@teams.size).floor)
      @teams.sample(numbers * 2).each_slice(2) do |team_ary|
        schedule_matches(@rounds, @tournament, team_ary)
      end
    end
  end

  def schedule_next_match
    rounds = @tournament.rounds
    teams = []
    auto_winners = []
    @teams.each do |team|
      unless team.already_in_rounds?(@tournament.rounds.first)
        auto_winners << team
      end
    end
    rounds.each do |round|
      round.matches.where(status: "played").each do |match|
        unless round.next.check_team(match.winner_team.id)
          teams += auto_winners
          teams << match.winner_team
          teams.each_slice(2) do |team_ary|
            round.next.matches.create(status: "prepare", style: "tournament",
                                      home_team: team_ary[0],
                                      invited_team: team_ary[1],
                                      game: @tournament.game)
          end
        end
      end
    end
  end

  private

  def schedule_matches(rounds, tournament, team_ary)
    rounds.first.matches.create(status: "prepare", style: "tournament",
                                home_team: team_ary[0],
                                invited_team: team_ary[1],
                                game: tournament.game)
  end
end
