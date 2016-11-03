require "rails_helper"

RSpec.describe Match, type: :model do
  describe "validations" do
    let(:tournament)   { create(:tournament) }
    let(:team_home)    { create(:team, :with_users, tournament: tournament) }
    let(:team_invited) { create(:team, :with_users, tournament: tournament) }
    let(:empty_team)   { build(:team) }
    let(:match)        { create(:match, home_team: team_home, invited_team: team_invited) }
    let(:second_match) { create(:match, home_team: team_home, invited_team: team_invited) }
    let(:bad_match)    { build(:match, home_team: team_home, invited_team: team_home) }
    let(:user)         { create(:user) }

    context "when valid data" do
      it { expect(match).to be_valid }

      it "team name must be eq team name in match" do
        expect(team_home.name).to eq(match.home_team.name)
        expect(team_invited.name).to eq(match.invited_team.name)
      end
    end

    context "when no teams assigned" do
      it "is invalid" do
        expect(bad_match).not_to be_valid
        expect(bad_match.errors.full_messages).to include("Can\'t be same team names")
      end
    end

    context "when no game assigned" do
      before { match.game = nil }

      it "is invalid" do
        expect(match).not_to be_valid
      end
    end

    context "when same player in different team" do
      before do
        team_home.users << user
        bad_match.home_team = team_home
        bad_match.invited_team = team_home
      end

      it "is invalid" do
        expect(bad_match).not_to be_valid
      end

      it "raises error" do
        bad_match.valid?
        expect(bad_match.errors.full_messages).to include("Same player in different teams")
      end
    end

    context "when no team score assigned" do
      before do
        match.home_team_score = nil
        match.invited_team_score = nil
      end

      it "is invalid" do
        expect(match).not_to be_valid
      end
    end

    context "when contains wrong status" do
      before { match.status = "Playing" }

      it "is invalid" do
        expect(match).not_to be_valid
      end
    end

    context "when status is not present" do
      before { match.status = nil }

      it "is invalid" do
        expect(match).not_to be_valid
      end
    end
  end
end
