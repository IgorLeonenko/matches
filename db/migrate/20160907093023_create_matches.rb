class CreateMatches < ActiveRecord::Migration[5.0]
  def change
    create_table :matches do |t|
      t.string  :status, null: false, default: 'prepare'
      t.string  :style, null: false, default: 'friendly'
      t.belongs_to :home_team, index: true, null: false
      t.belongs_to :invited_team, index: true, null: false
      t.integer :home_team_score, null: false, default: 0
      t.integer :invited_team_score, null: false, default: 0
      t.belongs_to :game, index: true, null: false
      t.belongs_to :round, index: true, null: false, default: 0

      t.timestamps
    end
  end
end
