require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'validations' do
    let(:user_igor) { build(:user) }
    let(:user_ivan) { build(:user) }

    context 'when valid data is given' do
      it { expect(user_ivan).to be_valid }
      it { expect(user_igor.avatar).to be_present}
    end

    context 'when name is not present' do
      before { user_igor.name = nil }

      it 'is invalid' do
        expect(user_igor).not_to be_valid
      end
    end

    context 'when name shorter than 3 chars' do
      before { user_igor.name = 'DJ' }

      it 'is invalid' do
        expect(user_igor).not_to be_valid
      end
    end

    context 'when username is not present' do
      before { user_igor.username = nil }

      it 'is invalid' do
        expect(user_igor).not_to be_valid
      end
    end

    context 'when username is the same for other user' do
      before do
        user_rob = create(:user)
        user_ivan.username = user_rob.username
      end

      it 'is invalid' do
        expect(user_ivan).not_to be_valid
        expect(user_ivan.errors.full_messages).to include('Username has already been taken')
      end
    end

    context 'when username is shorter than 3 chars' do
      before { user_igor.username = 'JD' }

      it 'is invalid' do
        expect(user_igor).not_to be_valid
      end
    end

    context 'when email is not present' do
      before { user_igor.email = nil }

      it 'is invalid' do
        expect(user_igor).not_to be_valid
      end
    end

    context 'when email is incorrect' do
      before { user_igor.email = 'incorrect_email' }

      it 'is invalid' do
        expect(user_igor).not_to be_valid
        expect(user_igor.errors.full_messages).to include("Email is invalid")
      end
    end
  end
end
