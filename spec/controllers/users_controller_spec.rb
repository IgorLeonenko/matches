require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  describe 'when user logged in' do
    before { login(user) }

    context 'GET #sign_up' do
      before { get :new }

      it { expect(response).to redirect_to matches_path }
      it { expect(flash[:notice]).to be_present }
      it { expect(flash[:notice]).to include('You are already logged in') }
    end
  end

  describe 'when user not logged in' do
    context 'GET #sign_up' do
      before { get :new }

      it { expect(response.status).to eq(200) }
      it { expect(response).to render_template('new') }
    end

    context 'POST #create with valid data' do
      subject { post :create, params: { user: attributes_for(:user) } }

      it { expect{subject}.to change(User, :count).by(1) }
      it { expect(subject).to redirect_to matches_path }
      it { expect(subject.response_code).to eq(302) }

      it 'has flash[:notice] message' do
        subject
        expect(flash[:notice]).to be_present
        expect(flash[:notice]).to include('User created sucessfully')
      end
    end

    context 'POST #create with invalid data' do
      subject { post :create, params: { user: attributes_for(:user, name: nil) } }

      it { expect{subject}.not_to change(User, :count) }
      it { expect(subject).to render_template('new') }
      it { expect(subject.response_code).to eq(200) }

      it 'has flash[:notice] message' do
        subject
        expect(flash[:alert]).to be_present
        expect(flash[:alert]).to include('Something wrong')
      end
    end
  end
end
