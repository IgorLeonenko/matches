class Match < ApplicationRecord

  STATUS = %w(prepare in\ game played)

  belongs_to :home_team, class_name: 'Team'
  belongs_to :invited_team, class_name: 'Team'

  validates :game_name, presence: true, uniqueness: true
  validates :home_team_score, presence: true, numericality: true
  validates :invited_team_score, presence: true, numericality: true
  validates :status, inclusion: { in: STATUS }, allow_nil: true
  validate  :player_can_be_only_in_one_team_on_match

  private

    def player_can_be_only_in_one_team_on_match
      if home_team.present? && invited_team.present? && !home_team.users.empty? && !invited_team.users.empty?
        if home_team.users == invited_team.users
          errors.add(:base, "Same player in different teams")
        end
      end
    end
end
