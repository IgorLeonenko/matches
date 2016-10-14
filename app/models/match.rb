class Match < ApplicationRecord

  STATUS = %w(prepare in\ game played)
  STYLE  = %W(friendly tournament)

  belongs_to :home_team, class_name: 'Team'
  belongs_to :invited_team, class_name: 'Team'
  belongs_to :game
  belongs_to :round

  validates :home_team, :invited_team, :game, :round_id,
            :status, presence: true
  validates :home_team_score, :invited_team_score, presence: true, numericality: true
  validates :status, inclusion: { in: STATUS }
  validate  :player_can_be_only_in_one_team_on_match
  validate  :cant_be_same_team_name

  accepts_nested_attributes_for :home_team, :invited_team


  def winner_team
    choose_winner_or_looser[0]
  end

  def loosing_team
    choose_winner_or_looser[1]
  end

  def can_be_played?
    unless round_id == 0
      if round.prev.present?
        if round.prev.finished?
          true
        else
          false
        end
      else
        true
      end
    else
      true
    end
  end

  private

  def cant_be_same_team_name
    return if round_id != 0

    teams_names = [home_team.name, invited_team.name]

    if teams_names.uniq.length != teams_names.length
      errors.add(:base, 'Can\'t be same team names')
    end
  end

  def choose_winner_or_looser
    if home_team_score > invited_team_score
      [home_team, invited_team]
    else
      [invited_team, home_team]
    end
  end

  def player_can_be_only_in_one_team_on_match
    return if home_team.blank? || invited_team.blank?

    unless home_team.user_ids & invited_team.user_ids == []
      errors.add(:base, "Same player in different teams")
    end
  end
end
