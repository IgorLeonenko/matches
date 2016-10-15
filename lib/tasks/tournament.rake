require_relative '../../app/workers/tournament_worker'
namespace :tournament do
  desc "Switch tournament to started"
  task start: :environment do
    Tournament.all.each do |tournament|
      if tournament.can_be_started?
        TournamentWorker.perform_async(tournament.id)
      elsif !tournament.can_be_started? && tournament.state == 'open'
        tournament.update_attribute(:start_date, tournament.start_date += 1.day)
      end
    end
  end

end
