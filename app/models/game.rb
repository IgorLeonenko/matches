class Game < ApplicationRecord
  has_many :matches

  validates :name, presence: true, uniqueness: true, length: { minimum: 4 }

  mount_uploader :image, GameImageUploader
end
