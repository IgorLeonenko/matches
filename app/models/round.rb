class Round < ApplicationRecord
  belongs_to :tournament

  has_many :matches

  validates :number, uniqueness: { scope: :tournament_id }

  def finished?
    matches.pluck(:status).all? { |el| el == "played" }
  end

  def next
    self.class.where("number > ? AND tournament_id = ?", number, tournament_id).first
  end

  def prev
    self.class.where("number < ? AND tournament_id = ?", number, tournament_id).last
  end

  def check_team(team_id)
    matches.exists?(home_team_id: team_id) || matches.exists?(invited_team_id: team_id)
  end
end
