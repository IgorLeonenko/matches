require 'rails_helper'

RSpec.describe Match, type: :model do

  describe '.validate' do
    let(:team_home)             { create(:team_with_users) }
    let(:team_invited)          { create(:team_with_users) }
    let(:empty_team)            { create(:team) }
    let(:match)                 { create(:match, home_team: team_home, invited_team: team_invited) }
    let(:second_match)          { create(:match, home_team: team_home, invited_team: team_invited) }
    let(:match_with_same_team)  { build(:match, home_team: team_home, invited_team: team_home) }
    let(:match_with_empty_team) { build(:match, home_team: empty_team, invited_team: team_invited) }

    context 'when invalid data' do
      it 'with same game name' do
        second_match.name = match.name
        expect(second_match).not_to be_valid
      end

      it 'without game name' do
        match.name = nil
        expect(match).not_to be_valid
      end

      it 'with name less than 5 chars' do
        match.name = 'free'
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

      it 'cant be empty team in match' do
        expect(match_with_empty_team).not_to be_valid
        expect(match_with_empty_team.errors.full_messages).to include('Can\'t be empty team in match')
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
