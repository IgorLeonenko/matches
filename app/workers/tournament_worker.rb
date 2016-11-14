class TournamentWorker
  include Sidekiq::Worker

  def perform
    Tournament.all.each do |tournament|
      if tournament.can_be_started?
        TournamentScheduler.new(tournament).start_tournament
      elsif !tournament.can_be_started? && tournament.state == "open"
        tournament.update_attribute(:start_date, tournament.start_date + 1.day)
      end
    end
  end
end
