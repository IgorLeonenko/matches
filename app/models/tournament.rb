class Tournament < ApplicationRecord
  STYLES = %w(deathmatch league).freeze
  STATES = %w(open started ended).freeze

  belongs_to :game

  has_many :tournament_users
  has_many :users, through: :tournament_users, dependent: :destroy

  has_many :teams, dependent: :destroy
  has_many :rounds

  validates :title, :start_date, :style, :state,
            :teams_quantity, :game_id, :players_in_team, presence: true
  validates :title, length: { minimum: 5 }
  validates :teams_quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :players_in_team, numericality: { only_integer: true }
  validates :description, length: { maximum: 500 }
  validates :style, inclusion: { in: STYLES }
  validates :state, inclusion: { in: STATES }
  validate  :teams_quantity_not_less_registered_teams
  validate  :players_quantity_not_less_registered_players

  accepts_nested_attributes_for :tournament_users

  mount_uploader :picture, TournamentPictureUploader

  def players_total_quantity
    (teams_quantity * players_in_team)
  end

  def creator
    User.find(creator_id).username
  end

  def full_of_teams?
    teams.size == teams_quantity
  end

  def full_of_players?
    players_in_team <= 0 || players_total_quantity == users.size
  end

  def not_started?
    Time.zone.today >= start_date && state == "open"
  end

  def can_be_started?
    full_of_teams? && full_of_players? && not_started?
  end

  private

  def teams_quantity_not_less_registered_teams
    if teams.size > teams_quantity
      errors.add(:base, "Can\'t be less than registered teams")
    end
  end

  def players_quantity_not_less_registered_players
    return if players_in_team == 0

    if teams.any? { |team| team.users.size > players_in_team}
      errors.add(:base, "Can\'t be less than registered players in team")
    end
  end
end
