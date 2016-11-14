class User < ApplicationRecord
  has_secure_password

  has_many :team_users
  has_many :teams, through: :team_users

  has_many :tournament_users
  has_many :tournaments, through: :tournament_users

  validates :name, :email, :username, presence: true
  validates :name, :username, length: { minimum: 3 }
  validates :email, uniqueness: true,
                    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/ }
  validates :username, uniqueness: true

  mount_uploader :avatar, AvatarUploader

  def creator?(tournament)
    id == Tournament.find(tournament.id).creator_id
  end
end
