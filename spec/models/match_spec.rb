require 'rails_helper'

RSpec.describe Match, type: :model do

  describe '.validate' do
    let(:team_home)             { create(:team_with_users) }
    let(:team_invited)          { create(:team_with_users) }
    let(:empty_team)            { create(:team) }
    let(:match)                 { create(:match, home_team: team_home, invited_team: team_invited) }
    let(:second_match)          { create(:match, home_team: team_home, invited_team: team_invited) }
    let(:match_without_teams)   { build(:match)}
    let(:match_with_same_team)  { build(:match, home_team: team_home, invited_team: team_home) }

    context 'when invalid data' do
      it 'with same game name' do
        second_match.name = match.name
        expect(second_match).not_to be_valid
      end

      it 'without teams' do
        expect(match_without_teams).not_to be_valid
        expect(match_without_teams.errors[:home_team]).to include('can\'t be blank')
        expect(match_without_teams.errors[:invited_team]).to include('can\'t be blank')
      end

      it 'without game' do
        match.game = nil
        expect(match).not_to be_valid
      end

      it 'with name less than 3 chars' do
        match.name = 'gb'
        expect(match).not_to be_valid
      end

      it 'rise error if same player in different team' do
        expect(match_with_same_team).to_not be_valid
        expect(match_with_same_team.errors.full_messages).to include('Same player in different teams')
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
