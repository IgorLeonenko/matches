class TeamTournament < ApplicationRecord
  belongs_to :team
  belongs_to :tournament

  validates :team, :tournament, presence: true
  validate  :cant_be_more_players_than_players_quantity

  private

  def cant_be_more_players_than_players_quantity
    return if tournament.players_in_team == 0

    if team.users.size > tournament.players_in_team
      errors.add(:base, 'Can\'t be more players than tournament players quantity')
    end
  end
end
