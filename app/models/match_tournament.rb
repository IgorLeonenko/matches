class MatchTournament < ApplicationRecord
  belongs_to :match
  belongs_to :tournament

  validates :tournament, :team, presence: true
end
