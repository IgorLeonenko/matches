class Match < ApplicationRecord

  STATUS = %w(prepare in\ game played)
  STYLE  = %W(friendly tournament)

  belongs_to :home_team, class_name: 'Team'
  belongs_to :invited_team, class_name: 'Team'
  belongs_to :game
  belongs_to :round

  validates :home_team, :invited_team, :game,
            :status, presence: true
  validates :home_team_score, :invited_team_score, presence: true, numericality: true
  validates :status, inclusion: { in: STATUS }
  validate  :player_can_be_only_in_one_team_on_match


  def winner_team
    choose_winner_or_looser[0]
  end

  def loosing_team
    choose_winner_or_looser[1]
  end

  def can_be_played?
    if round.prev.present?
      if round.prev.finished?
        true
      else
        false
      end
    else
      true
    end
  end

  private

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
