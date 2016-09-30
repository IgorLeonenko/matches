class Team < ApplicationRecord
  has_many :team_users
  has_many :users, through: :team_users, dependent: :destroy
  has_many :matches

  belongs_to :tournament

  validates :name, presence: true, uniqueness: { scope: :tournament_id }, length: { minimum: 5 }
  validates :users, presence: true
  validates :tournament_id, presence: true

end
