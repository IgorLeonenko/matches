require 'rails_helper'

RSpec.describe Match, type: :model do

  describe 'validations' do
    let(:team_home)    { create(:team_with_users) }
    let(:team_invited) { create(:team_with_users) }
    let(:empty_team)   { build(:team) }
    let(:match)        { create(:match, home_team: team_home, invited_team: team_invited) }
    let(:second_match) { create(:match, home_team: team_home, invited_team: team_invited) }
    let(:bad_match)    { build(:match) }
    let(:user)         { create(:user) }

    context 'when valid data' do
      it { expect(match).to be_valid }

      it 'team name must be eq team name in match' do
        expect(team_home.name).to eq(match.home_team.name)
        expect(team_invited.name).to eq(match.invited_team.name)
      end
    end

    context 'when same game name' do
      before { second_match.name = match.name }

      it 'is invalid' do
        expect(second_match).not_to be_valid
      end
    end

    context 'when without teams' do

      it 'is invalid' do
        expect(bad_match).not_to be_valid
        expect(bad_match.errors[:home_team]).to include('can\'t be blank')
        expect(bad_match.errors[:invited_team]).to include('can\'t be blank')
      end
    end

    context 'when without game' do
      before { match.game = nil }

      it 'is invlaid' do
        expect(match).not_to be_valid
      end
    end

    context 'when name less tahn 3 chars' do
      before { match.name = 'gb' }

      it 'is invalid' do
        expect(match).not_to be_valid
      end
    end

    context 'when same player in different team' do
      before do
        team_home.users << user
        bad_match.home_team = team_home
        bad_match.invited_team = team_home
      end

      it 'is invalid' do
        expect(bad_match).to_not be_valid
      end

      it 'raise error' do
        bad_match.valid?
        expect(bad_match.errors.full_messages).to include('Same player in different teams')
      end
    end

    context 'when without team score' do
      before do
        match.home_team_score = nil
        match.invited_team_score = nil
      end

      it 'is invalid' do
        expect(match).not_to be_valid
      end
    end

    context 'when contain wrong status' do
      before { match.status = 'Playing' }

      it 'is invalid' do
        expect(match).not_to be_valid
      end
    end

    context 'when status is not present' do
      before { match.status = nil }

      it 'without status' do
        expect(match).not_to be_valid
      end
    end
  end
end
