class User < ApplicationRecord
  has_secure_password

  has_many :teams_users
  has_many :teams, through: :teams_users

  validates :name, presence: true
  validates :name, :username, length: { minimum: 3 }
  validates :email, presence: true,
                    uniqueness: true,
                    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/}
  validates :username, presence: true, uniqueness: true

  mount_uploader :avatar, AvatarUploader
end
