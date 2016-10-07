require_relative '../../app/workers/tournament_worker'
namespace :tournament do
  desc "Switch tournament to started"
  task start: :environment do
    Tournament.all.each do |tournament|
      TournamentWorker.perform_async(tournament.id)
    end
  end

end
