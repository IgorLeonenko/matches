require 'rails_helper'

RSpec.describe MatchesController, type: :controller do
  let(:test_match) { create(:match, home_team: create(:team_with_users), invited_team: create(:team_with_users)) }
  # let(:new_match) { build(:match, home_team: test_match.home_team, invited_team: test_match.invited_team) }

  describe 'GET #index' do
    before { get :index }

    it { expect(response.status).to eq(200) }
    it { expect(response).to render_template('index') }

    context 'assigns @matches' do
      it { expect(assigns(:matches)).to eq([test_match]) }
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: test_match } }

    it { expect(response).to render_template('show') }

    context 'assigns requested @match' do
      it { expect(assigns(:match)).to eq(test_match) }
    end

    context "returns 404 response" do
      before { get :show, params: { id: 'bad_id' } }

      it { expect(response.status).to eq(404) }
      it { expect(response).to render_template(file: "#{Rails.root}/public/404.html") }
    end
  end

  describe 'POST #create' do

    context 'with valid attributes' do
      it 'create a new match' do
        expect{ post :create, match: test_match.attributes }.to change(Match, :count).to(1)
      end

    end
  end
end
