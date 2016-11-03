require "rails_helper"

RSpec.describe Api::V1::TournamentsController, type: :controller do
  let(:user)            { create(:user) }
  let(:test_tournament) { create(:tournament, :with_teams, creator_id: user.id) }

  context "when user logged in" do
    before { login(user) }

    describe "GET #index" do
      context "render index page" do
        before do
          test_tournament
          get :index
        end

        it { expect(response.status).to eq(200) }
        it { expect(json.count).to eq(1) }
      end
    end

    describe "GET #show" do
      context "render show page" do
        before { get :show, params: { id: test_tournament } }

        it { expect(response.status).to eq(200) }
        it { expect(json["id"]).to eq(test_tournament.id) }
      end

      context "assigns requested @tournament" do
        before do
          get :show, params: { id: test_tournament }
        end

        it { expect(assigns(:tournament)).to eq(test_tournament) }
      end
    end

    describe "POST #create" do
      context "with valid attributes" do
        subject(:create_valid) { post :create, params: { tournament: attributes_for(:tournament) } }

        it { expect { create_valid }.to change(Tournament, :count).by(1) }
        it "create a new tournament" do
          create_valid
          expect(json["id"]).to eq(Tournament.last.id)
        end
      end

      context "with invalid attributes" do
        subject(:create_invalid) { post :create, params: { tournament: attributes_for(:tournament,
                                                                                      title: nil) } }
        it { expect { create_invalid }.not_to change(Tournament, :count) }
        it { expect(create_invalid.response_code).to eq(422) }
      end
    end

    describe "PUT #update" do
      context "when @tournament state is open" do
        context "with valid attributes" do
          subject(:update_valid) do
            put :update, params: { id: test_tournament,
                                   tournament: attributes_for(:tournament, title: "TestTournament") }
          end

          it "located the requested @tournament" do
            update_valid
            expect(assigns(:tournament)).to eq(test_tournament)
          end

          it "change @tournament attributes" do
            update_valid
            test_tournament.reload
            expect(test_tournament.title).to eq("TestTournament")
          end
        end

        context "with invalid attributes" do
          subject(:update_invalid) do
            put :update, params: { id: test_tournament,
                                   tournament: attributes_for(:tournament, title: nil) }
          end

          it "does not change @tournament attributes" do
            update_invalid
            expect(test_tournament.title).to eq(test_tournament.title)
          end
        end
      end
    end

    describe "DELETE #destroy" do
      before { test_tournament }

      context "with valid attributes" do
        subject(:delete_tournament) { delete :destroy, params: { id: test_tournament.id } }

        it { expect(delete_tournament.response_code).to eq(204) }

        it { expect { delete_tournament }.to change(Tournament, :count).by(-1) }
      end

      context "when current user is not creator" do
        before do
          test_tournament.creator_id = 6789
          test_tournament.save
          delete :destroy, params: { id: test_tournament.id }
        end

        it { expect(response.code).to eq("422") }
        it { expect(Tournament.count).to eq(1) }
        it { expect(json["errors"]).to eq("You are not creator") }
      end

      context "when tournament state ended or started" do
        before do
          test_tournament.state = "ended"
          test_tournament.save
          delete :destroy, params: { id: test_tournament.id }
        end

        it { expect(response.code).to eq("422") }
        it { expect(Tournament.count).to eq(1) }
        it { expect(json["errors"]).to eq("Tournament started or ended") }
      end
    end
  end
end
