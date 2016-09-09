class Match < ApplicationRecord
  belongs_to :home_team, class_name: 'Team'
  belongs_to :invited_team, class_name: 'Team'

  validates :game_name, presence: true, uniqueness: true
  validates :home_team_score, presence: true, numericality: true
  validates :invited_team_score, presence: true, numericality: true
  validate  :players_in_team

  def players_in_team
    if home_team.present? && invited_team.present?
      errors.add(:base, "Same player in different teams") if home_team.users == invited_team.users
    end
  end
end
