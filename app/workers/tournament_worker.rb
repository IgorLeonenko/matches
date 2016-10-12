class TournamentWorker
  include Sidekiq::Worker

  def perform(tournament_id)
    tournament = Tournament.find(tournament_id)
    TournamentScheduler.new(tournament).start_tournament
  end
end
