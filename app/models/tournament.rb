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
    if players_in_team > 0
      if players_total_quantity == users.size
        true
      else
        false
      end
    else
      true
    end
  end

  def not_started?
    Time.zone.today >= start_date && state == "open"
  end

  def can_be_started?
    full_of_teams? && full_of_players? && not_started?
  end
end
