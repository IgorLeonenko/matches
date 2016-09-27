class MatchTournament < ApplicationRecord
  belongs_to :match
  belongs_to :tournament

  validates :tournament, :match, presence: true
end
