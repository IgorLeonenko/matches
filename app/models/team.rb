class Team < ApplicationRecord
  has_many :team_users
  has_many :users, through: :team_users
  has_many :matches

  validates :name, presence: true, uniqueness: true, length: { minimum: 5 }
  validates :users, presence: true

end
