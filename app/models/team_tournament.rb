class TeamTournament < ApplicationRecord
  belongs_to :team
  belongs_to :tournament

  validates :team, :tournament, presence: true
end
