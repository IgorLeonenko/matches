require 'rails_helper'

RSpec.describe Match, type: :model do

  describe '.validate' do
    let(:team_home)            { create(:team) }
    let(:team_invited)         { create(:team) }
    let(:full_team)            { create(:team_with_users) }
    let(:match)                { build(:match, home_team: team_home, invited_team: team_invited) }
    let(:match_with_full_team) { build(:match, home_team: full_team, invited_team: full_team) }

    context 'when invalid data' do
      it 'with same game name' do
        match_same = match
        expect(match_same).not_to be_valid
      end

      it 'rise error if same player in different team' do
        expect(match_with_full_team).to be_invalid
        expect(match_with_full_team.errors.full_messages).to include('Same player in different teams')
      end
    end

    context 'when valid data' do
      it 'team name must be eq match team name' do
        expect(team_home.name).to eq(match.home_team.name)
        expect(team_invited.name).to eq(match.invited_team.name)
      end
    end
  end
end
