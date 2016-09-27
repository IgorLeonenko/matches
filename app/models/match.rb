class Match < ApplicationRecord

  STATUS = %w(prepare in\ game played)

  belongs_to :home_team, class_name: 'Team'
  belongs_to :invited_team, class_name: 'Team'
  belongs_to :game

  has_many :match_tournaments
  has_many :tournaments, through: :match_tournaments

  validates :home_team, :invited_team, :game,
            :name, :status, presence: true
  validates :name, uniqueness: true, length: { minimum: 3 }
  validates :home_team_score, :invited_team_score, presence: true, numericality: true
  validates :status, inclusion: { in: STATUS }
  validate  :player_can_be_only_in_one_team_on_match

  private

    def player_can_be_only_in_one_team_on_match
      return if home_team.blank? || invited_team.blank?

      unless home_team.user_ids & invited_team.user_ids == []
        errors.add(:base, "Same player in different teams")
      end
    end
end
