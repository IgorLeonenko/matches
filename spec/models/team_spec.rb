require 'rails_helper'

RSpec.describe Team, type: :model do

  describe '.validate' do
    let(:first_team) { create(:team) }
    let(:second_team) { create(:team) }

    context 'when invalid data' do
      it 'with same team name' do
        first_team.name = second_team.name
        expect(first_team).not_to be_valid
      end
    end

    context 'when valid data' do
      it { expect(first_team).to be_valid }
    end
  end
end
