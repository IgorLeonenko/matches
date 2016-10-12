class Round < ApplicationRecord
  belongs_to :tournament

  has_many :matches

  validates :number, uniqueness: { scope: :tournament_id }

  def finished?
    if matches.any?
      matches.where(status: 'played').size == matches.size ? true : false
    end
  end

  def next
    self.class.where("number > ?", number).first
  end

  def prev
    self.class.where("number < ?", number).last
  end

  def check_team(team_id)
    matches.exists?(home_team_id: team_id) || matches.exists?(invited_team_id: team_id)
  end
end
