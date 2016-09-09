class RemoveSizeFromTeam < ActiveRecord::Migration[5.0]
  def change
    remove_column :teams, :size, :integer
  end
end
