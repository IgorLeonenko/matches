require "rails_helper"

RSpec.describe TeamsController, type: :controller do
  let(:user)       { create(:user) }
  let(:tournament) { create(:tournament, creator_id: user.id) }
  let(:team)       { create(:team, :with_users, tournament: tournament) }
  let(:full_tournament) { create(:tournament, :with_teams, creator_id: user.id) }

  context "when user logged in" do
    before { login(user) }

    describe "POST #create" do
      context "with valid attributes" do
        subject(:create_valid) do
          post :create, params: { tournament_id: tournament.id,
                                  team: { name: "good team", user_ids: [user.id] } }
        end

        it { expect { create_valid }.to change(Team, :count).by(1) }
        it { expect { create_valid }.to change(TeamUser, :count).by(1) }
        it { expect(create_valid).to redirect_to(tournament) }

        context "add correct datas to database" do
          before { create_valid }

          it { expect(TeamUser.first.user_id).to eq(user.id) }
          it { expect(TeamUser.first.team_id).to eq(Team.first.id) }
          it { expect(tournament.teams.size).to eq(1) }
          it { expect(tournament.teams.first.id).to eq(Team.first.id) }
          it { expect(tournament.users.first.id).to eq(user.id) }
        end
      end

      context "with invalid data" do
        context "when user is not added" do
          before do
            post :create, params: { tournament_id: tournament.id,
                                    team: { name: "good team", user_ids: [] } }
          end

          it { expect(response).to render_template("new") }
          it { expect(Team.count).to eq(0) }
          it { expect(TeamUser.count).to eq(0) }
          it { expect(flash[:alert]).to include("Validation failed: Users can\'t be blank") }
        end

        context "when name is not present" do
          before do
            post :create, params: { tournament_id: tournament.id,
                                    team: { name: "", user_ids: [user.id] } }
          end

          it { expect(response).to render_template("new") }
          it { expect(Team.count).to eq(0) }
          it { expect(TeamUser.count).to eq(0) }
          it { expect(flash[:alert]).to include("Validation failed: Name can\'t be blank") }
        end

        context "when one of users already in tournament" do
          let(:tournament_with_users) { create(:tournament, :with_users) }
          before do
            post :create, params: { tournament_id: tournament_with_users.id,
                                    team: { name: "good team",
                                            user_ids: [tournament_with_users.users.first.id] } }
          end

          it { expect(response).to render_template("new") }
          it { expect(flash[:alert]).to include("Validation failed: User already in tournament") }
          it { expect { response }.not_to change(Team, :count) }
          it { expect { response }.not_to change(TeamUser, :count) }
        end

        context "when teams more than tournament teams quantity" do
          before do
            post :create, params: { tournament_id: full_tournament.id,
                                    team: { name: "good team", user_ids: [user.id] } }
          end

          it { expect(response).to render_template("new") }
          it { expect(flash[:alert]).to include("Validation failed: Can\'t be more teams than teams quantity") }
          it { expect { response }.not_to change(Team, :count) }
          it { expect { response }.not_to change(TeamUser, :count) }
        end

        context "when players more than tournament players quantity" do
          let(:users) { create_list(:user, 3) }
          before do
            post :create, params: { tournament_id: tournament.id,
                                    team: { name: "good team", user_ids: [users.map(&:id)] } }
          end

          it { expect(response).to render_template("new") }
          it { expect(flash[:alert]).to include("Validation failed: Can\'t be more players than players in team") }
          it { expect { response }.not_to change(Team, :count) }
          it { expect { response }.not_to change(TeamUser, :count) }
        end
      end
    end

    describe "DELETE" do
      before { full_tournament }

      context "#delete team from tournament" do
        subject(:delete_team) do
          delete :destroy, params: { tournament_id: full_tournament.id,
                                     id: full_tournament.teams[0].id }
        end

        it { expect { delete_team }.to change(Team, :count).by(-1) }
        it { expect { delete_team }.to change(TournamentUser, :count).by(-2) }
        it { expect(delete_team).to redirect_to(full_tournament) }
      end

      context "#delete user from tournament" do
        subject(:delete_user) do
          delete :remove_user, params: { tournament_id: full_tournament.id,
                                         team_id: full_tournament.teams[0].id,
                                         user_id: full_tournament.teams[0].users[0].id }
        end

        it { expect { delete_user }.to change(TeamUser, :count).by(-1) }
        it { expect { delete_user }.to change(TournamentUser, :count).by(-1) }
        it { expect(delete_user).to redirect_to(full_tournament) }
      end
    end
  end
end
