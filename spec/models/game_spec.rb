require 'rails_helper'

RSpec.describe Game, type: :model do
  describe '.validate' do
    let(:game) { build(:game) }

    context 'when valid data' do
      it { expect(game).to be_valid }
      it { expect(game.image).to be_present }
    end

    context 'when invalid data' do
      it 'without name' do
        game.name = nil
        expect(game).not_to be_valid
      end

      it 'with less tahn 5 chars in name' do
        game.name = 'trol'
        expect(game).not_to be_valid
      end
    end
  end
end
