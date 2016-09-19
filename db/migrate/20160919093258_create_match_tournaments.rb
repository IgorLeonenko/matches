class CreateMatchTournaments < ActiveRecord::Migration[5.0]
  def change
    create_table :match_tournaments do |t|
      t.belongs_to :match, foreign_key: true, null: false
      t.belongs_to :tournament, foreign_key: true, null: false

      t.timestamps
    end
  end
end
