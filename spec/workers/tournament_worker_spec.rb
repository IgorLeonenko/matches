require 'rails_helper'

RSpec.describe TournamentWorker, type: :worker do
  let(:user)        { create(:user) }
  let(:tournament)  { create(:tournament, :with_teams, creator_id: user.id, players_in_team: 4)}
  let(:job)         { TournamentWorker.new }
  subject(:perform) { job.perform(tournament.id)}

  context "#perform" do

    it 'add job' do
      expect{TournamentWorker.perform_async(tournament.id)}.to change(TournamentWorker.jobs, :size).by(1)
    end

    it 'change tournament status' do
      expect{perform}.to change{tournament.reload.state}.from('open').to('started')
    end

    it 'create rounds' do
      expect{perform}.to change{tournament.reload.rounds.size}.by(1)
    end

    it 'schedule match' do
      perform
      expect(Match.count).to eq(1)
      expect(Match.first.round_id).to eq(tournament.rounds.first.id)
      expect(Match.first.home_team_id).to_not be_nil
      expect(Match.first.invited_team_id).to_not be_nil
    end
  end
end
