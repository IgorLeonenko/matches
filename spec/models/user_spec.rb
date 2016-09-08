require 'rails_helper'

RSpec.describe User, type: :model do

  describe '.validate' do
    let(:user_igor) { create(:user) }
    let(:user_ivan) { create(:user) }

    context 'when valid data is given' do
      it { expect(user_ivan).to be_valid }
    end

    context 'when invalid data is given' do

      it 'with same username' do
        user_igor.username = user_ivan.username
        expect(user_igor).not_to be_valid
      end

      it 'with name charecter less then 5' do
        user_igor.name = 'igor'
        expect(user_igor).not_to be_valid
      end

      it 'with incorrect email' do
        user_igor.email = 'incorrect_email'
        expect(user_igor).not_to be_valid
      end
    end
  end
end
