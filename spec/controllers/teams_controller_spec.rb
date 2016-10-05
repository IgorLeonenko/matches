require 'rails_helper'

RSpec.describe TeamsController, type: :controller do
  let(:user)       { create(:user) }
  let(:tournament) { create(:tournament, creator_id: user.id) }
  let(:team)       { create(:team, :with_users, tournament: tournament) }

  context 'when user logged in' do
    before { login(user) }

    describe 'POST #create' do
      context 'with valid attributes' do
        subject do
          post :create, params: { tournament_id: tournament.id,
                        team: { name: 'good team', user_ids: [user.id] } }
        end

        it { expect { subject }.to change(Team, :count).by(1) }
        it { expect { subject }.to change(TeamUser, :count).by(1) }
        it { expect(subject).to redirect_to(tournament) }

        context 'add correct datas to database' do
          before { subject }

          it { expect(TeamUser.first.user_id).to eq(user.id) }
          it { expect(TeamUser.first.team_id).to eq(Team.first.id) }
          it { expect(tournament.teams.size).to eq(1) }
          it { expect(tournament.teams.first.id).to eq(Team.first.id) }
          it { expect(tournament.users.first.id).to eq(user.id) }
        end
      end

      context 'with invalid data' do
        context 'when user is not added' do
          before do
            post :create, params: { tournament_id: tournament.id,
                          team: { name: 'good team', user_ids: [] } }
          end

          it { expect(response).to render_template('new') }
          it { expect(Team.count).to eq(0) }
          it { expect(TeamUser.count).to eq(0) }
          it { expect(flash[:alert]).to include('Validation failed: Users can\'t be blank') }
        end

        context 'when name is not present' do
          before do
            post :create, params: { tournament_id: tournament.id,
                          team: { name: '', user_ids: [user.id] } }
          end

          it { expect(response).to render_template('new') }
          it { expect(Team.count).to eq(0) }
          it { expect(TeamUser.count).to eq(0) }
          it { expect(flash[:alert]).to include('Validation failed: Name can\'t be blank') }
        end

        context 'when one of users already in tournament' do
          let(:tournament_with_users) { create(:tournament, :with_users) }
          before do
            post :create, params: { tournament_id: tournament_with_users.id,
                          team: { name: 'good team',
                                  user_ids: [tournament_with_users.users.first.id] } }
          end

          it { expect(response).to render_template('new') }
          it { expect(flash[:alert]).to include('Validation failed: User already in tournament') }
          it { expect{ response }.to_not change(Team, :count) }
          it { expect{ response }.to_not change(TeamUser, :count) }
        end

        context 'when teams more than tournament teams quantity' do
          let(:full_tournament) { create(:tournament, :with_teams) }
          before do
            post :create, params: { tournament_id: full_tournament.id,
                          team: { name: 'good team', user_ids: [user.id] } }
          end

          it { expect(response).to render_template('new') }
          it { expect(flash[:alert]).to include('Validation failed: Can\'t be more teams than teams quantity') }
          it { expect{ response }.to_not change(Team, :count) }
          it { expect{ response }.to_not change(TeamUser, :count) }
        end

        context 'when players more than tournament players quantity' do
          let(:users) { create_list(:user, 3) }
          before do
            post :create, params: { tournament_id: tournament.id,
                          team: { name: 'good team', user_ids: [users.map(&:id)] } }
          end

          it { expect(response).to render_template('new') }
          it { expect(flash[:alert]).to include('Validation failed: Can\'t be more players than players in team') }
          it { expect{ response }.to_not change(Team, :count) }
          it { expect{ response }.to_not change(TeamUser, :count) }
        end
      end
    end
  end
end
