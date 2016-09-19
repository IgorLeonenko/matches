require 'rails_helper'

RSpec.describe Tournament, type: :model do
  describe 'validation' do
    let(:tournament) { build(:tournament) }
    let(:user)       { create(:user) }
    let(:team)       { create(:team_with_users) }

    context 'when valid data' do
      it { expect(tournament).to be_valid }
    end

    context 'when title is not present' do
      before { tournament.title = nil }

      it { expect(tournament).not_to be_valid }
    end

    context 'when title shorter than 5 chars' do
      before { tournament.title = 'less' }

      it { expect(tournament).not_to be_valid }
    end

    context 'when start date is not present' do
      before { tournament.start_date = nil }

      it { expect(tournament).not_to be_valid }
    end

    context 'when style is not present' do
      before { tournament.style = nil }

      it { expect(tournament).not_to be_valid }
    end

    context 'when contains wrong style' do
      before { tournament.style = 'bad_style' }

      it { expect(tournament).not_to be_valid }
    end

    context 'when state is not present' do
      before { tournament.state = nil }

      it { expect(tournament).not_to be_valid }
    end

    context 'when contains wrong state' do
      before { tournament.state = 'bad_state' }

      it { expect(tournament).not_to be_valid }
    end

    context 'when teams quantity is not present' do
      before { tournament.teams_quantity = nil }

      it { expect(tournament).not_to be_valid }
    end

    context 'when teams quantity less than 0' do
      before { tournament.teams_quantity = -1 }

      it { expect(tournament).not_to be_valid }
    end

    context 'when game is not assigned' do
      before { tournament.game = nil }

      it { expect(tournament).not_to be_valid }
    end

    context 'when description more than 500 chars' do
      before { tournament.description = Faker::Lorem.characters(550) }

      it { expect(tournament).not_to be_valid }
    end

    context 'when same player in one tournament' do
      before do
        tournament.save
        tournament.users << user
      end

      it 'is invalid' do
        expect { tournament.users << user }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when add more teams than teams_quantity' do
      before do
        tournament.teams_quantity = 2
        3.times do
          tournament.teams << team
        end
      end

      it 'is invalid' do
        tournament.valid?
        expect(tournament.errors.full_messages).to include('Can\'t be more teams than teams quantity')
      end
    end

    context 'when add more users than players quantity' do
      before do
        tournament.teams_quantity = 2
        tournament.players_in_team = 2
        2.times do
          tournament.teams << team
        end
        tournament.teams[0].users << user
      end

      it 'is invalid' do
        tournament.valid?
        expect(tournament).not_to be_valid
      end
    end
  end
end
