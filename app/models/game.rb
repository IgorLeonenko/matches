class Game < ApplicationRecord
  has_many :matches

  validates :name, presence: true, uniqueness: true, length: { minimum: 5 }

  mount_uploader :image, GameImageUploader
end
