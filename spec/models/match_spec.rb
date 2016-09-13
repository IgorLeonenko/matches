require 'rails_helper'

RSpec.describe Match, type: :model do

  describe '.validate' do
    let(:team_home)             { build(:team_with_users) }
    let(:team_invited)          { build(:team_with_users) }
    let(:empty_team)            { build(:team) }
    let(:match)                 { create(:match, home_team: team_home, invited_team: team_invited) }
    let(:second_match)          { create(:match, home_team: team_home, invited_team: team_invited) }
    let(:bad_match)   { build(:match) }
    let(:user) { create(:user) }

    context 'when invalid data' do
      it 'with same game name' do
        second_match.name = match.name
        expect(second_match).not_to be_valid
      end

      it 'without teams' do
        expect(bad_match).not_to be_valid
        expect(bad_match.errors[:home_team]).to include('can\'t be blank')
        expect(bad_match.errors[:invited_team]).to include('can\'t be blank')
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
        team_home.users << user
        bad_match.home_team = team_home
        bad_match.invited_team = team_home
        expect(bad_match).to_not be_valid
        expect(bad_match.errors.full_messages).to include('Same player in different teams')
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

      it 'without status' do
        match.status = nil
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
