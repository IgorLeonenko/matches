require "rails_helper"

RSpec.describe Api::V1::UsersController, type: :controller do
  describe "POST #create with valid data" do
    subject(:create_valid) { post :create, params: { user: attributes_for(:user) } }

    it { expect { create_valid }.to change(User, :count).by(1) }
    it 'return correct json' do
      create_valid
      expect(json["id"]).to eq(User.last.id)
    end
  end

  describe "POST #create with invalid data" do
    subject(:create_invalid) { post :create, params: { user: attributes_for(:user, name: nil) } }

    it { expect { create_invalid }.not_to change(User, :count) }
    it { expect(create_invalid.response_code).to eq(422) }
  end
end
