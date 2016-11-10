require "rails_helper"

RSpec.describe Api::V1::MatchesController, type: :controller do
  let(:user)       { create(:user) }
  let(:tournament) { create(:tournament) }
  let(:team_1)     { create(:team, :with_users, tournament: tournament) }
  let(:team_2)     { create(:team, :with_users, tournament: tournament) }
  let(:test_match) { create(:match, home_team: team_1, invited_team: team_2) }

  context "when user logged in" do
    before { login(user) }

    describe "GET #index" do
      context "return correct json" do
        before do
          test_match
          get :index
        end

        it { expect(response.status).to eq(200) }
        it { expect(json.count).to eq(1) }
      end
    end

    describe "POST #create" do
      context "with valid attributes" do
        subject(:create_valid) do
          post :create, params: { match: attributes_for(:match,
                                                        home_team_attributes:
                                                          {
                                                            name: team_1.name,
                                                            user_ids: team_1.users.map(&:id),
                                                          },
                                                        invited_team_attributes:
                                                          {
                                                            name: team_2.name,
                                                            user_ids: team_2.users.map(&:id),
                                                          }) }
        end

        it { expect { create_valid }.to change(Match, :count).by(1) }
        it "return correct json" do
          create_valid
          expect(json["id"]).to eq(Match.last.id)
        end
      end

      context "with invalid attributes" do
        subject(:create_invalid) do
          post :create, params: { match: attributes_for(:match,
                                                        home_team_attributes: { name: "" },
                                                        invited_team_attributes: { name: "" }) }
        end

        it { expect { create_invalid }.not_to change(Match, :count) }
        it { expect(create_invalid.response_code).to eq(422) }
      end
    end

    describe "PUT #update" do
      context "with valid attributes" do
        subject(:update_valid) do
          put :update, params: { id: test_match,
                                 match: attributes_for(:match,
                                                       status: 'in game',
                                                       home_team_id: team_1.id,
                                                       invited_team_id: team_2.id) }
        end

        it "located the requested @match" do
          update_valid
          expect(assigns(:match)).to eq(test_match)
        end

        it "change @match attributes" do
          update_valid
          test_match.reload
          expect(test_match.status).to eq("in game")
        end
      end

      context "with invalid attributes" do
        subject(:update_invalid) do
          put :update, params: { id: test_match,
                                 match: attributes_for(:match,
                                                       status: nil,
                                                       home_team_id: nil,
                                                       invited_team_id: team_2.id) }
        end

        it { expect(update_invalid.response_code).to eq(422) }

        it "does not change @match attributes" do
          update_invalid
          test_match.reload
          expect(test_match.status).to eq(test_match.status)
        end
      end
    end

    describe "DELETE #destroy" do
      before { test_match }

      subject(:delete_match) do
        delete :destroy, params: { id: test_match.id }
      end

      it { expect(delete_match.response_code).to eq(204) }

      it "deletes the @match" do
        expect { delete_match }.to change(Match, :count).by(-1)
      end
    end
  end
end
