require 'rails_helper'

RSpec.describe Team, type: :model do

  describe 'validations' do
    let(:first_team)  { build(:team_with_users) }
    let(:second_team) { build(:team_with_users) }
    let(:empty_team)  { build(:team) }
    let(:user)        { create(:user) }

    context 'when valid data' do
      before { empty_team.users << user }

      it { expect(empty_team).to be_valid }
    end

    context 'when same team name' do
      before do
        second_team.save
        first_team.name = second_team.name
      end

      it 'is invalid' do
        expect(first_team).not_to be_valid
      end
    end

    context 'when name less than 5 chars' do
      before { first_team.name = 'free' }

      it 'is invalid' do
        expect(first_team).not_to be_valid
      end
    end

    context 'when try to add same player in team' do
      before do
        empty_team.users << user
        empty_team.save
      end

      it 'is invalid' do
        expect{empty_team.users << user}.to raise_error(ActiveRecord::RecordInvalid,'Validation failed: User already in team')
      end
    end
  end
end
