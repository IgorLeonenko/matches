class CreateTournaments < ActiveRecord::Migration[5.0]
  def change
    create_table :tournaments do |t|
      t.string :title, null: false
      t.text :description
      t.datetime :start_date, null: false, default: Time.zone.today
      t.string :picture
      t.string :style, null: false, default: 'deathmatch'
      t.string :state, null: false, default: 'open'
      t.integer :teams_quantity, null: false, default: 0
      t.integer :players_in_team, null: false, default: 0
      t.integer :creator_id
      t.belongs_to :game, foreign_key: true, null: false

      t.timestamps
    end
  end
end
