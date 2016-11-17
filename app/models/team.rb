class Team < ApplicationRecord
  has_many :team_users
  has_many :users, through: :team_users, dependent: :destroy
  has_many :matches

  belongs_to :tournament

  validates :name, presence: true, uniqueness: { scope: :tournament_id }, length: { minimum: 5 }
  validates :team_users, presence: { message: "cant be blank" }
  validates :tournament_id, presence: true
  validate  :tournament_players_quantity
  validate  :tournament_teams_quantity

  accepts_nested_attributes_for :tournament

  def assign_users_to_team(users_ids)
    unless users_ids.nil?
      users_ids.each do |user_id|
        team_users.build(user_id: user_id)
        tournament.tournament_users.build(user_id: user_id) if tournament
      end
    end
  end

  def already_in_rounds?(round)
    round.check_team(id) || round.next.check_team(id)
  end

  private

  def tournament_players_quantity
    return unless tournament

    if tournament.players_in_team > 0 && tournament.players_in_team < team_users.size
      errors.add(:base, "Can\'t be more players than players in team")
    end
  end

  def tournament_teams_quantity
    return unless tournament

    if tournament.teams_quantity < tournament.teams.size
      errors.add(:base, "Can\'t be more teams than teams quantity")
    end
  end
end
