class Team < ApplicationRecord
  has_many :team_users
  has_many :users, through: :team_users, dependent: :destroy

  has_many :team_tournaments
  has_many :tournaments, through: :team_tournaments

  has_many :matches

  validates :name, presence: true, uniqueness: true, length: { minimum: 5 }
  validates :users, presence: true

end
