require "rails_helper"

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  context "when user logged in" do
    before { login(user) }

    describe "GET #sign_up" do
      before { get :new }

      it { expect(response).to redirect_to matches_path }
      it { expect(flash[:notice]).to be_present }
      it { expect(flash[:notice]).to include("You are already logged in") }
    end
  end

  context "when user not logged in" do
    describe "GET #sign_up" do
      before { get :new }

      it { expect(response.status).to eq(200) }
      it { expect(response).to render_template("new") }
    end

    describe "POST #create with valid data" do
      subject(:create_valid) { post :create, params: { user: attributes_for(:user) } }

      it { expect { create_valid_user }.to change(User, :count).by(1) }
      it { expect(create_valid).to redirect_to matches_path }
      it { expect(create_valid.response_code).to eq(302) }

      it "has flash[:notice] message" do
        create_valid
        expect(flash[:notice]).to be_present
        expect(flash[:notice]).to include("User created sucessfully")
      end
    end

    describe "POST #create with invalid data" do
      subject(:create_invalid) { post :create, params: { user: attributes_for(:user, name: nil) } }

      it { expect { create_invalid }.not_to change(User, :count) }
      it { expect(create_invalid).to render_template("new") }
      it { expect(create_invalid.response_code).to eq(200) }

      it "has flash[:notice] message" do
        create_invalid
        expect(flash[:alert]).to be_present
        expect(flash[:alert]).to include("Something wrong")
      end
    end
  end
end
