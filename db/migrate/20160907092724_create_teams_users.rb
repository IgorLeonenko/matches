class CreateTeamsUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :teams_users do |t|
      t.belongs_to :team, index: true
      t.belongs_to :user, index: true
    end
  end
end
