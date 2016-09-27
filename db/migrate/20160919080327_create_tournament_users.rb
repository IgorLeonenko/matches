class CreateTournamentUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :tournament_users do |t|
      t.belongs_to :tournament, foreign_key: true, null: false
      t.belongs_to :user, foreign_key: true, null: false

      t.timestamps
    end

    add_index :tournament_users, [ :tournament_id, :user_id ], unique: true
  end
end
