class Tournament < ApplicationRecord

  STYLE = %w(league deathmatch)
  STATE = %w(open started ended)

  belongs_to :game

  has_many :tournament_users
  has_many :users, through: :tournament_users

  has_many :match_tournaments
  has_many :matches, through: :match_tournaments

  validates :title, :start_date, :style, :state,
            :teams_quantity, :game, presence: true
  validates :teams_quantity, :players_in_team, numericality: true
  validates :description, length: { maximum: 500 }
  validates :style, inclusion: { in: STYLE }
  validates :state, inclusion: { in: STATE }
end
