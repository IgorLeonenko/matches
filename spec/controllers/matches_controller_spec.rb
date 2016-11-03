require "rails_helper"

RSpec.describe MatchesController, type: :controller do
  let(:user)       { create(:user) }
  let(:tournament) { create(:tournament) }
  let(:team_1)     { create(:team, :with_users, tournament: tournament) }
  let(:team_2)     { create(:team, :with_users, tournament: tournament) }
  let(:test_match) { create(:match, home_team: team_1, invited_team: team_2) }

  context "when user logged in" do
    before { login(user) }

    describe "GET #index" do
      context "render index page" do
        before { get :index }

        it { expect(response.status).to eq(200) }
        it { expect(response).to render_template("index") }
      end
    end

    describe "GET #show" do
      context "render show page" do
        before { get :show, params: { id: test_match } }

        it { expect(response.status).to eq(200) }
        it { expect(response).to render_template("show") }
      end

      context "assigns requested @match" do
        before do
          get :show, params: { id: test_match }
        end

        it { expect(assigns(:match)).to eq(test_match) }
      end

      context "returns 404 response" do
        before { get :show, params: { id: "bad_id" } }

        it { expect(response.status).to eq(404) }
        it { expect(response).to render_template(file: "#{Rails.root}/public/404.html") }
      end
    end

    describe "POST #create" do
      context "with valid attributes" do
        subject(:create_valid) do
          post :create, params: { match: attributes_for(:match,
                                                        home_team_attributes:
                                                          {
                                                            name: team_1.name,
                                                            user_ids: [team_1.users.map(&:id)],
                                                          },
                                                        invited_team_attributes:
                                                          {
                                                            name: team_2.name,
                                                            user_ids: [team_2.users.map(&:id)],
                                                          }) }
        end

        it "create a new match" do
          expect { create_valid }.to change(Match, :count).by(1)
        end

        it "redirects to @match" do
          expect(create_valid).to redirect_to Match.last
          expect(create_valid.response_code).to eq(302)
        end

        it "has flash[:notice] message" do
          create_valid
          expect(flash[:notice]).to be_present
          expect(flash[:notice]).to include("Match created sucessfully")
        end
      end

      context "with invalid attributes" do
        subject(:create_invalid) do
          post :create, params: { match: attributes_for(:match,
                                                        home_team_attributes: { name: "" },
                                                        invited_team_attributes: { name: "" }) }
        end

        it "not create a new match" do
          expect { create_invalid }.not_to change(Match, :count)
        end

        it "re-render action new" do
          expect(create_invalid).to render_template(:new)
          expect(create_invalid.response_code).to eq(200)
        end

        it "has flash[:alert] message" do
          create_invalid
          expect(flash[:alert]).to be_present
        end
      end
    end

    describe "PUT #update" do
      context "with valid attributes" do
        subject(:update_valid) do
          put :update, params: { id: test_match,
                                 match: attributes_for(:match,
                                                       home_team_id: team_1.id,
                                                       invited_team_id: team_2.id) }
        end

        it "located the requested @match" do
          update_valid
          expect(assigns(:match)).to eq(test_match)
        end

        it "change @match attributes" do
          put :update, params: { id: test_match, match: attributes_for(:match, status: "in game", home_team_id: team_1.id, invited_team_id: team_2.id) }
          test_match.reload
          expect(test_match.status).to eq("in game")
        end

        it "redirects to updated @match" do
          expect(update_valid).to redirect_to(test_match)
          expect(update_valid.response_code).to eq(302)
        end

        it "has flash[:notice] message" do
          update_valid
          expect(flash[:notice]).to be_present
          expect(flash[:notice]).to include("Match edited sucessfully")
        end
      end

      context "with invalid attributes" do
        subject(:update_invalid) do
          put :update, params: { id: test_match,
                                 match: attributes_for(:match,
                                                       status: nil,
                                                       home_team_id: nil,
                                                       invited_team_id: team_2.id) }
          test_match.reload
        end

        it "does not change @match attributes" do
          update_invalid
          expect(test_match.status).to eq(test_match.status)
        end

        it "re-render action edit" do
          expect(update_invalid).to render_template(:edit)
          expect(response.code).to eq("200")
        end

        it "has flash[:alert] message" do
          update_invalid
          expect(flash[:alert]).to be_present
        end
      end
    end

    describe "DELETE #destroy" do
      before { test_match }

      context "with valid attributes" do
        subject(:delete) { delete :destroy, params: { id: test_match.id } }

        it "deletes the @match" do
          expect { delete }.to change(Match, :count).by(-1)
        end

        it "redirects to matches#index" do
          expect(delete).to redirect_to(matches_path)
        end

        it "has flash[:notice] message" do
          delete
          expect(flash[:notice]).to be_present
          expect(flash[:notice]).to include("Match deleted sucessfully")
        end
      end
    end
  end

  context "when user not logged" do
    before { logout }

    context "GET #index" do
      before { get :index }

      it { expect(response).to redirect_to(log_in_path) }
    end

    context "POST #create" do
      before do
        post :create, params: { match: attributes_for(:match,
                                                      home_team_id: team_1.id,
                                                      invited_team_id: team_2.id) }
      end

      it { expect(response).to redirect_to(log_in_path) }
    end

    context "PUT #update" do
      before do
        put :update, params: { id: test_match,
                               match: attributes_for(:match,
                                                     name: "Test",
                                                     home_team_id: nil,
                                                     invited_team_id: team_2.id) }
        test_match.reload
      end

      it { expect(response).to redirect_to(log_in_path) }
    end

    context "DELETE #destroy" do
      before do
        test_match
        delete :destroy, params: { id: test_match.id }
      end

      it { expect(response).to redirect_to(log_in_path) }
    end
  end
end
