class RemoveResultFromMatch < ActiveRecord::Migration[5.0]
  def change
    remove_column :matches, :result, :string
  end
end
