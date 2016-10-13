require 'rails_helper'

RSpec.describe MatchWorker, type: :worker do
  let(:user)                   { create(:user) }
  let(:tournament)             { create(:tournament, creator_id: user.id,
                                        teams_quantity: 4) }
  let(:teams)                  { build_list(:team, 4, :with_users) }
  let(:job_tournament)         { TournamentWorker.new }
  subject(:perform_tournament) { job_tournament.perform(tournament.id) }
  let(:job_match)              { MatchWorker.new }
  subject(:perform_match)      { job_match.perform(tournament.id) }

  context '#perform' do
    before do
      teams.each do |team|
        tournament.teams << team
        team.save
      end
      perform_tournament
      tournament.rounds.first.matches.each do |match|
        match.update_attributes(status: 'played', home_team_score: 1)
      end
    end

    it 'add job' do
      expect{MatchWorker.perform_async(tournament.id)}.to change(MatchWorker.jobs, :size).by(1)
    end

    it 'add match to next round' do
      expect{perform_match}.to change(Match, :count).by(1)
    end

    it 'add to next round winner team' do
      perform_match
      team1 = tournament.rounds[0].matches[0].winner_team
      team2 = tournament.rounds[0].matches[1].winner_team

      expect(tournament.rounds[1].matches[0].home_team.id).to eq(team1.id)
      expect(tournament.rounds[1].matches[0].invited_team.id).to eq(team2.id)
    end
  end
end
