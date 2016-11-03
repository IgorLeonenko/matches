require "rails_helper"

RSpec.describe Game, type: :model do
  describe "validations" do
    let(:game) { build(:game) }

    context "when valid data" do
      it { expect(game).to be_valid }
      it { expect(game.image).to be_present }
    end

    context "when name is not present" do
      before { game.name = nil }

      it "is invalid" do
        expect(game).not_to be_valid
      end
    end

    context "when name shorter than 5 chars" do
      before { game.name = "tro" }

      it "is invalid" do
        expect(game).not_to be_valid
      end
    end
  end
end
