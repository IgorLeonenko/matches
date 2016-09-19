class TournamentUser < ApplicationRecord
  belongs_to :tournament
  belongs_to :user

  validates :tournament, :team, presence: true
  validates :user_id, uniqueness: { scope: :tournament_id, message: 'already in tournament' }
end
