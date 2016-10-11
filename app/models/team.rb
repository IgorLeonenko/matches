class Team < ApplicationRecord
  has_many :team_users
  has_many :users, through: :team_users, dependent: :destroy
  has_many :matches

  belongs_to :tournament

  validates :name, presence: true, uniqueness: { scope: :tournament_id }, length: { minimum: 5 }
  validates :users, presence: true
  validates :tournament_id, presence: true
  validate  :cant_be_more_players_than_tournament_players_quantity
  validate  :cant_be_more_teams_than_tournament_teams_quantity

  def assign_users_to_team(users_ids)
    unless users_ids.nil?
      users_ids.each do |user_id|
        users << User.find(user_id)
        tournament.users << User.find(user_id)
      end
    end
  end

  def in_first_round?(round)
    round.matches.exists?(home_team_id: id) || round.matches.exists?(invited_team_id: id)
  end

  private

  def cant_be_more_players_than_tournament_players_quantity
    if tournament.players_in_team.present? && tournament.players_in_team < users.size
      errors.add(:base, 'Can\'t be more players than players in team')
    end
  end

  def cant_be_more_teams_than_tournament_teams_quantity
    if tournament.teams_quantity < tournament.teams.size
      errors.add(:base, 'Can\'t be more teams than teams quantity')
    end
  end
end
