class CreateMatches < ActiveRecord::Migration[5.0]
  def change
    create_table :matches do |t|
      t.string  :name, null: false
      t.string  :status
      t.belongs_to :home_team, index: true, null: false
      t.belongs_to :invited_team, index: true, null: false
      t.integer :home_team_score, default: 0
      t.integer :invited_team_score, default: 0
      t.belongs_to :game, index: true, null: false

      t.timestamps
    end

    add_index :matches, :name, unique: true
  end
end
