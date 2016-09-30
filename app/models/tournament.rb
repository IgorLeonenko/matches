class Tournament < ApplicationRecord

  STYLE = %w(league deathmatch)
  STATE = %w(open started ended)

  belongs_to :game

  has_many :tournament_users
  has_many :users, through: :tournament_users, dependent: :destroy

  has_many :match_tournaments
  has_many :matches, through: :match_tournaments

  has_many :teams, dependent: :destroy

  validates :title, :start_date, :style, :state,
            :teams_quantity, :game_id, presence: true
  validates :title, length: { minimum: 5 }
  validates :teams_quantity, numericality: {
                                               only_integer: true, greater_than: 0 }
  validates :description, length: { maximum: 500 }
  validates :style, inclusion: { in: STYLE }
  validates :state, inclusion: { in: STATE }

  mount_uploader :picture, TournamentPictureUploader

  def players_total_quantity
    (teams_quantity * players_in_team)
  end

  def creator
    User.find(creator_id).username
  end

  def add_team!(team)
    if teams.size >= teams_quantity
      raise 'Validation failed: Can\'t be more teams than teams quantity'
    else
      teams << team
    end
  end

  def add_user!(team)
    if !players_in_team.nil? && team.users.size > players_in_team
      raise 'Validation failed: Can\'t be more players than players in team'
    else
      if team.new_record?
        team.users.each do |user|
          users << user
        end
      else
        users << team.users.last
      end
    end
  end

end
