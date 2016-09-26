class TeamTournament < ApplicationRecord
  belongs_to :team
  belongs_to :tournament

  validates :team, :tournament, presence: true
  validate  :cant_be_more_players_than_players_quantity
  validate  :cant_be_teams_with_same_players
  validates :team_id, uniqueness: { scope: :tournament_id, message: 'already in tournament' }

  private

  def cant_be_more_players_than_players_quantity
    return if tournament.players_in_team == nil

    if team.users.size > tournament.players_in_team
      errors.add(:base, 'Can\'t be more players than tournament players quantity')
    end
  end

  def cant_be_teams_with_same_players
    unless (team.user_ids & tournament.user_ids).empty?
      errors.add(:base, "One of player\'s already in tournament")
    end
  end
end
