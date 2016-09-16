require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user)   { create(:user) }

  describe 'when user logged in' do
    before { login(user) }

    context 'GET #log_in' do
      before { get :new }

      it { expect(response).to redirect_to(matches_path) }
      it { expect(flash[:notice]).to be_present }
      it { expect(flash[:notice]).to include('You are already logged in') }
    end

    context 'DELETE #destroy' do
      before do
        delete :destroy
      end

      it { expect(response).to redirect_to(log_in_path) }
      it { expect(flash[:notice]).to be_present }
      it { expect(flash[:notice]).to include('You are logged out!') }
    end
  end

  describe 'when user not logged in' do
    context 'GET #login' do
      before { get :new }

      it { expect(response.status).to eq(200) }
      it { expect(response).to render_template('new') }
    end

    context 'POST #create with valid attributes' do
      before do
        post :create, params: { email: user.email, password: user.password }
      end

      it { expect(response.status).to eq (302) }
      it { expect(response).to redirect_to(matches_path)}
      it { expect(flash[:notice]).to be_present }
      it { expect(flash[:notice]).to include('You are logged in!') }
    end

    context 'POST #create with invalid attributes' do
      before do
        post :create, params: { email: user.email, password: 'bad_password' }
      end

      it { expect(response.status).to eq(200) }
      it { expect(response).to render_template('new') }
      it { expect(flash[:alert]).to be_present }
      it { expect(flash[:alert]).to include('Email or password incorrect') }
    end
  end
end
