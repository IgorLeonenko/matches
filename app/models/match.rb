class Match < ApplicationRecord

  STATUS = %w(prepare in\ game played)

  belongs_to :home_team, class_name: 'Team'
  belongs_to :invited_team, class_name: 'Team'
  belongs_to :game

  validates :home_team, presence: true
  validates :invited_team, presence: true
  validates :game, presence: true
  validates :name, presence: true, uniqueness: true, length: { minimum: 3 }
  validates :home_team_score, presence: true, numericality: true
  validates :invited_team_score, presence: true, numericality: true
  validates :status, inclusion: { in: STATUS }, allow_nil: true
  validate  :player_can_be_only_in_one_team_on_match

  private

    def player_can_be_only_in_one_team_on_match
      if home_team.present? && invited_team.present? && home_team.users.any? && invited_team.users.any?
        unless home_team.users & invited_team.users == []
          errors.add(:base, "Same player in different teams")
        end
      end
    end
end
