require 'rails_helper'

RSpec.describe User, type: :model do

  describe '.validate' do
    let(:user_igor) { create(:user) }
    let(:user_ivan) { create(:user) }

    context 'when valid data is given' do
      it { expect(user_ivan).to be_valid }
    end

    context 'when invalid data is given' do

      it 'without name' do
        user_igor.name = nil
        expect(user_igor).not_to be_valid
      end

      it 'without username' do
        user_igor.username = nil
        expect(user_igor).not_to be_valid
      end

      it 'with same username' do
        user_igor.username = user_ivan.username
        expect(user_igor).not_to be_valid
      end

      it 'with name charecter less then 5' do
        user_igor.name = 'igor'
        expect(user_igor).not_to be_valid
      end

      it 'without email' do
        user_igor.email = nil
        expect(user_igor).not_to be_valid
      end

      it 'with incorrect email' do
        user_igor.email = 'incorrect_email'
        expect(user_igor).not_to be_valid
        expect(user_igor.errors.full_messages).to include("Email is invalid")
      end
    end
  end
end
