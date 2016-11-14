class MatchWorker
  include Sidekiq::Worker

  def perform(tournament_id)
    tournament = Tournament.find(tournament_id)
    TournamentScheduler.new(tournament).schedule_next_match
  end
end
