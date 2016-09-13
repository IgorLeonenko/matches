class CreateTeamsUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :teams_users do |t|
      t.belongs_to :team, index: true, null: false
      t.belongs_to :user, index: true, null: false
    end

    add_index :teams_users, [ :team_id, :user_id ], unique: true
  end
end
