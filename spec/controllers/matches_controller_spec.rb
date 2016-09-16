require 'rails_helper'

RSpec.describe MatchesController, type: :controller do

  let(:user)   { create(:user) }
  let(:team_1) { create(:team_with_users) }
  let(:team_2) { create(:team_with_users) }
  let(:test_match) { create(:match, home_team: team_1, invited_team: team_2 ) }

  describe 'GET #index' do
    before { login(user) }
    context 'render index page' do
      before { get :index }

      it { expect(response.status).to eq(200) }
      it { expect(response).to render_template('index') }
    end
  end

  describe 'GET #show' do
    before { login(user) }

    context 'render show page' do
      before { get :show, params: { id: test_match } }

      it { expect(response.status).to eq(200) }
      it { expect(response).to render_template('show') }
    end

    context 'assigns requested @match' do
      before do
        login(user)
        get :show, params: { id: test_match }
      end

      it { expect(assigns(:match)).to eq(test_match) }
    end

    context "returns 404 response" do
      before { get :show, params: { id: 'bad_id' } }

      it { expect(response.status).to eq(404) }
      it { expect(response).to render_template(file: "#{Rails.root}/public/404.html") }
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      subject { post :create, params: { match: attributes_for(:match,
                                               home_team_id: team_1.id,
                                               invited_team_id: team_2.id ) } }

      it 'create a new match' do
        expect { subject }.to change(Match, :count).by(1)
      end

      it 'redirects to @match' do
        expect(subject).to redirect_to Match.last
        expect(subject.response_code).to eq(302)
      end

      it 'has flash[:notice] message' do
        subject
        expect(flash[:notice]).to be_present
        expect(flash[:notice]).to include('Match created sucessfully')
      end
    end

    context 'with invalid attributes' do
      subject { post :create, params: { match: attributes_for(:match,
                                               home_team_id: 'bad_id',
                                               invited_team_id: 'bad_id' ) } }
      it 'not create a new match' do
        expect { subject }.to_not change(Match, :count)
      end

      it 're-render action new' do
        expect(subject).to render_template(:new)
        expect(subject.response_code).to eq(200)
      end

      it 'has flash[:alert] message' do
        subject
        expect(flash[:alert]).to be_present
        expect(flash[:alert]).to include('Something wrong')
      end
    end
  end

  describe 'PUT #update' do
    before { login(user) }

    context 'with valid attributes' do
      subject { put :update, params: { id: test_match, match: attributes_for(:match,
                                                       home_team_id: team_1.id,
                                                       invited_team_id: team_2.id ) } }

      it 'located the requested @match' do
        subject
        expect(assigns(:match)).to eq(test_match)
      end

      it 'change @match attributes' do
        put :update, params: { id: test_match, match: attributes_for(:match,
                                                      name: 'TestMatch',
                                                      home_team_id: team_1.id,
                                                      invited_team_id: team_2.id ) }
        test_match.reload
        expect(test_match.name).to eq('TestMatch')
      end

      it 'redirects to updated @match' do
        expect(subject).to redirect_to(test_match)
        expect(subject.response_code).to eq(302)
      end

      it 'has flash[:notice] message' do
        subject
        expect(flash[:notice]).to be_present
        expect(flash[:notice]).to include('Match edited sucessfully')
      end
    end

    context 'with invalid attributes' do
      subject do
        put :update, params: { id: test_match, match: attributes_for(:match,
                                                       name: nil,
                                                       home_team_id: nil,
                                                       invited_team_id: team_2.id ) }
        test_match.reload
      end

      it 'does not change @match attributes' do
        subject
        expect(test_match.name).to eq(test_match.name)
      end

      it 're-render action edit' do
        expect(subject).to render_template(:edit)
        expect(response.code).to eq('200')
      end

      it 'has flash[:alert] message' do
        subject
        expect(flash[:alert]).to be_present
        expect(flash[:alert]).to include('Something went wrong ')
      end
    end
  end

  describe 'DELETE #destroy' do
    before  do
      login(user)
      test_match
    end

    context 'with valid attributes' do

      subject { delete :destroy, params: { id: test_match.id } }

      it 'deletes the @match' do
        expect { subject }.to change(Match, :count).by(-1)
      end

      it 'redirects to matches#index' do
        expect(subject).to redirect_to(matches_path)
      end

      it 'has flash[:notice] message' do
        subject
        expect(flash[:notice]).to be_present
        expect(flash[:notice]).to include('Match deleted sucessfully')
      end
    end
  end

  describe 'when user not logged' do
    before { logout }

    context 'GET #index' do
      before { get :index }

      it { expect(response).to redirect_to(root_path) }
    end

    context 'POST #create' do
      before do
        post :create, params: { match: attributes_for(:match,
                                      home_team_id: team_1.id,
                                      invited_team_id: team_2.id ) }
      end

      it { expect(response).to redirect_to(root_path) }
    end

    context 'PUT #update' do
      before do
        put :update, params: { id: test_match, match: attributes_for(:match,
                                                      name: 'Test',
                                                      home_team_id: nil,
                                                      invited_team_id: team_2.id ) }
        test_match.reload
      end

      it { expect(response).to redirect_to(root_path) }
    end

    context 'DELETE #destroy' do
      before do
        test_match
        delete :destroy, params: { id: test_match.id }
      end

      it { expect(response).to redirect_to(root_path) }
    end
  end
end
