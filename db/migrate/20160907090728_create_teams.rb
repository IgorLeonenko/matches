class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.belongs_to :tournament, index: true, null: false, default: 0

      t.timestamps
    end
  end
end
