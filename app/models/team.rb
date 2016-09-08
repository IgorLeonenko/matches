class Team < ApplicationRecord
  has_many :teams_users
  has_many :users, through: :teams_users
  has_many :matches

  validates :name, presence: true, uniqueness: true

end
