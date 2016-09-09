require 'rails_helper'

RSpec.describe Match, type: :model do

  describe '.validate' do
    let(:team_home)            { create(:team) }
    let(:team_invited)         { create(:team) }
    let(:full_team)            { create(:team_with_users) }
    let(:match)                { create(:match, home_team: team_home, invited_team: team_invited) }
    let(:second_match)         { create(:match, home_team: team_home, invited_team: team_invited) }
    let(:match_with_full_team) { build(:match, home_team: full_team, invited_team: full_team) }

    context 'when invalid data' do
      it 'with same game name' do
        second_match.game_name = match.game_name
        expect(second_match).not_to be_valid
      end

      it 'without game name' do
        match.game_name = nil
        expect(match).not_to be_valid
      end

      it 'rise error if same player in different team' do
        expect(match_with_full_team).to_not be_valid
        expect(match_with_full_team.errors.full_messages).to include('Same player in different teams')
      end

      it 'without team score' do
        match.home_team_score = nil
        match.invited_team_score = nil
        expect(match).not_to be_valid
      end

      it 'contain wrong status' do
        match.status = 'Playing'
        expect(match).not_to be_valid
      end
    end

    context 'when valid data' do
      it { expect(match).to be_valid }

      it 'team name must be eq match team name' do
        expect(team_home.name).to eq(match.home_team.name)
        expect(team_invited.name).to eq(match.invited_team.name)
      end

    end
  end
end
