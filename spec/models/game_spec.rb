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

      it 'with name less than 5 chars' do
        game.name = 'tro'
        expect(game).not_to be_valid
      end
    end
  end
end
