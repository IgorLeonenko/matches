class CreateMatches < ActiveRecord::Migration[5.0]
  def change
    create_table :matches do |t|
      t.string  :game_name
      t.string  :status
      t.integer :home_team_id, foreign_key: true
      t.integer :invited_team_id, foreign_key: true
      t.integer :home_team_score, default: 0
      t.integer :invited_team_score, default: 0

      t.timestamps
    end
  end
end
