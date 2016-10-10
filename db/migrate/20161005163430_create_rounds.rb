class CreateRounds < ActiveRecord::Migration[5.0]
  def change
    create_table :rounds do |t|
      t.integer :number
      t.belongs_to :tournament, index: true, null: false

      t.timestamps
    end

    add_index :rounds, :number, unique: true
  end
end
