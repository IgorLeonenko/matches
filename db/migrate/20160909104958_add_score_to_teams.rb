class AddScoreToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :matches, :home_team_score, :integer, default: 0
    add_column :matches, :invited_team_score, :integer, default: 0
  end
end
