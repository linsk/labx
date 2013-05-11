class CreateTotals < ActiveRecord::Migration
  def change
    create_table :totals do |t|
      t.timestamp :start
      t.timestamp :end
      t.string :counter
      t.references :user

      t.timestamps
    end
    add_index :totals, :user_id
  end
end
