class Tournament < ApplicationRecord

  STYLE = %w(league deathmatch)
  STATE = %w(open started ended)

  belongs_to :game

  has_many :tournament_users
  has_many :users, through: :tournament_users, dependent: :destroy

  has_many :match_tournaments
  has_many :matches, through: :match_tournaments

  has_many :team_tournaments
  has_many :teams, through: :team_tournaments

  validates :title, :start_date, :style, :state,
            :teams_quantity, :game, presence: true
  validates :title, length: { minimum: 5 }
  validates :teams_quantity, numericality: {
                                               only_integer: true, greater_than: 0 }
  validates :description, length: { maximum: 500 }
  validates :style, inclusion: { in: STYLE }
  validates :state, inclusion: { in: STATE }
  validate  :cant_be_more_teams_than_teams_quantity

  mount_uploader :picture, TournamentPictureUploader

  def players_total_quantity
    (teams_quantity * players_in_team)
  end

  def creator
    User.find(creator_id).username
  end

  private

  def cant_be_more_teams_than_teams_quantity
    return if teams_quantity.blank?

    if teams.size > teams_quantity
      errors.add(:base, "Can\'t be more teams than teams quantity")
    end
  end
end
