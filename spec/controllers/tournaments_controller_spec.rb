require 'rails_helper'

RSpec.describe TournamentsController, type: :controller do
  let(:user)            { create(:user) }
  let(:test_tournament) { create(:tournament, creator_id: user.id) }

  context 'when user logged in' do
    before { login(user) }

    describe 'GET #index' do
      context 'render index page' do
        before { get :index }

        it { expect(response.status).to eq(200) }
        it { expect(response).to render_template('index') }
      end
    end

    describe 'GET #show' do
      context 'render show page' do
        before { get :show, params: { id: test_tournament } }

        it { expect(response.status).to eq(200) }
        it { expect(response).to render_template('show') }
      end

      context 'assigns requested @tournament' do
        before do
          get :show, params: { id: test_tournament }
        end

        it { expect(assigns(:tournament)).to eq(test_tournament) }
      end

      context "returns 404 response" do
        before { get :show, params: { id: 'bad_id' } }

        it { expect(response.status).to eq(404) }
        it { expect(response).to render_template(file: "#{Rails.root}/public/404.html") }
      end
    end

    describe 'POST #create' do
      context 'with valid attributes' do
        subject { post :create, params: { tournament: attributes_for(:tournament) } }

        it 'create a new tournament' do
          expect { subject }.to change(Tournament, :count).by(1)
        end

        it 'redirects to @tournament' do
          expect(subject).to redirect_to Tournament.last
          expect(subject.response_code).to eq(302)
        end

        it 'has flash[:notice] message' do
          subject
          expect(flash[:notice]).to be_present
          expect(flash[:notice]).to include('Tournament created sucessfully')
        end
      end

      context 'with invalid attributes' do
        subject { post :create, params: { tournament: attributes_for(:tournament,
                                                                     title: nil) } }
        it 'not create a new tournament' do
          expect { subject }.to_not change(Tournament, :count)
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
      context 'when @tournament state is open' do
        context 'with valid attributes' do
          subject { put :update, params: { id: test_tournament, tournament: attributes_for(:tournament) } }

          it 'located the requested @tournament' do
            subject
            expect(assigns(:tournament)).to eq(test_tournament)
          end

          it 'change @tournament attributes' do
            put :update, params: { id: test_tournament, tournament: attributes_for(:tournament,
                                                                    title: 'TestTournament') }
            test_tournament.reload
            expect(test_tournament.title).to eq('TestTournament')
          end

          it 'redirects to updated @tournament' do
            expect(subject).to redirect_to(test_tournament)
            expect(subject.response_code).to eq(302)
          end

          it 'has flash[:notice] message' do
            subject
            expect(flash[:notice]).to be_present
            expect(flash[:notice]).to include('Tournament edited sucessfully')
          end
        end

        context 'with invalid attributes' do
          subject do
            put :update, params: { id: test_tournament, tournament: attributes_for(:tournament,
                                                               title: nil) }
            test_tournament.reload
          end

          it 'does not change @tournament attributes' do
            subject
            expect(test_tournament.title).to eq(test_tournament.title)
          end

          it 're-render action edit' do
            expect(subject).to render_template(:edit)
            expect(response.code).to eq('200')
          end

          it 'has flash[:alert] message' do
            subject
            expect(flash[:alert]).to be_present
            expect(flash[:alert]).to include('Something went wrong')
          end
        end
      end

      context 'when @tournament state is ended' do
        before do
          test_tournament.state = 'ended'
          test_tournament.save
          get :edit, params: { id: test_tournament }
        end

        it { expect(response).to redirect_to(tournaments_path) }
        it { expect(flash[:alert]).to be_present }
        it { expect(flash[:alert]).to include('You are not creator of tournament or tournament ended') }
      end

      context 'when current user is not a creator' do
        before do
          test_tournament.creator_id = 6789
          test_tournament.save
          get :edit, params: { id: test_tournament }
        end

        it { expect(response).to redirect_to(tournaments_path) }
        it { expect(flash[:alert]).to be_present }
        it { expect(flash[:alert]).to include('You are not creator of tournament or tournament ended') }
      end
    end

    describe 'DELETE #destroy' do
      before { test_tournament }

      context 'with valid attributes' do

        subject { delete :destroy, params: { id: test_tournament.id } }

        it 'deletes the @match' do
          expect { subject }.to change(Tournament, :count).by(-1)
        end

        it 'redirects to matches#index' do
          expect(subject).to redirect_to(tournaments_path)
        end

        it 'has flash[:notice] message' do
          subject
          expect(flash[:notice]).to be_present
          expect(flash[:notice]).to include('Tournament deleted sucessfully')
        end
      end

      context 'when current user is not creator' do
        before do
          test_tournament.creator_id = 6789
          test_tournament.save
          delete :destroy, params: { id: test_tournament.id }
        end

        it { expect(response).to redirect_to(tournaments_path) }
        it { expect(flash[:alert]).to be_present }
        it { expect(flash[:alert]).to include('You are not creator') }
      end

      context 'when tournament state ended or started' do
        before do
          test_tournament.state = 'ended'
          test_tournament.save
          delete :destroy, params: { id: test_tournament.id }
        end

        it { expect(response).to redirect_to(tournaments_path) }
        it { expect(flash[:alert]).to be_present }
        it { expect(flash[:alert]).to include('Tournament started or ended') }
      end
    end
  end

  context 'when user not logged' do
    before { logout }

    context 'GET #index' do
      before { get :index }

      it { expect(response).to redirect_to(log_in_path) }
    end

    context 'POST #create' do
      before do
        post :create, params: { tournament: attributes_for(:tournament) }
      end

      it { expect(response).to redirect_to(log_in_path) }
    end

    context 'PUT #update' do
      before do
        put :update, params: { id: test_tournament,
                               tournament: attributes_for(:tournament, title: 'Test') }
        test_tournament.reload
      end

      it { expect(response).to redirect_to(log_in_path) }
    end

    context 'DELETE #destroy' do
      before do
        test_tournament
        delete :destroy, params: { id: test_tournament.id }
      end

      it { expect(response).to redirect_to(log_in_path) }
    end
  end
end
