require 'rails_helper'

RSpec.describe User, type: :model do

  describe '.validate' do
    let(:user_igor) { build(:user) }
    let(:user_ivan) { build(:user) }

    context 'when valid data is given' do
      it { expect(user_ivan).to be_valid }
      it { expect(user_igor.avatar).to be_present}
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
        user_rob = create(:user)
        user_ivan.username = user_rob.username
        expect(user_ivan).not_to be_valid
        expect(user_ivan.errors.full_messages).to include('Username has already been taken')
      end

      it 'with name less than 3 chars' do
        user_igor.name = 'DJ'
        expect(user_igor).not_to be_valid
      end

      it 'with username less than 3 chars' do
        user_igor.username = 'JD'
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
