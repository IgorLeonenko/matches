class AddTeamToMatch < ActiveRecord::Migration[5.0]
  def change
    add_column :matches, :home_team_id, :integer, foreign_key: true
    add_column :matches, :invited_team_id, :integer, foreign_key: true
  end
end
