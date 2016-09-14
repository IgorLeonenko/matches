class TeamUser < ApplicationRecord
  belongs_to :team
  belongs_to :user

  validates :user, :team, presence: true
  validates :user_id, uniqueness: { scope: :team_id, message: 'already in team' }
end
