require 'rails_helper'

RSpec.describe Team, type: :model do

  describe '.validate' do
    let(:first_team)  { create(:team) }
    let(:second_team) { create(:team) }
    let(:user)        { create(:user) }

    context 'when invalid data' do
      it 'with same team name' do
        first_team.name = second_team.name
        expect(first_team).not_to be_valid
      end

      it 'with name less than 5 chars' do
        first_team.name = 'free'
        expect(first_team).not_to be_valid
      end

      it 'try to add same player to team' do
        first_team.users << user
        expect{first_team.users << user}.to raise_error(ActiveRecord::RecordInvalid,'Validation failed: User already in team')
      end
    end

    context 'when valid data' do
      it { expect(first_team).to be_valid }
    end
  end
end
