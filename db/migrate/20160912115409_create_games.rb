class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.string :name, null: false
      t.string :image

      t.timestamps
    end

    add_index :games, :name, unique: true
  end
end
