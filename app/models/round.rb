class Round < ApplicationRecord
  belongs_to :tournament

  has_many :matches

  def finished
    if matches.any?
      matches.where(status: 'played').size == matches.size ? true : false
    end
  end
end
