class Match < ApplicationRecord
  belongs_to :home_team, class_name: 'Team'
  belongs_to :invited_team, class_name: 'Team'

  validates  :game_name, presence: true, uniqueness: true
  validate   :players_in_team

  def players_in_team
    if self.home_team.users == self.invited_team.users
      errors.add(:base, "Same player in different teams")
    end
  end
end
