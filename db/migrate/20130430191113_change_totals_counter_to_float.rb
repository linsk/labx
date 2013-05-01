class ChangeTotalsCounterToFloat < ActiveRecord::Migration
  def change
    change_column :totals, :counter, :float
  end
end
