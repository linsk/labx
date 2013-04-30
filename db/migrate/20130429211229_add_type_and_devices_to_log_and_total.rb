class AddTypeAndDevicesToLogAndTotal < ActiveRecord::Migration
  def change
  	add_column :logs, :device, :string
  	add_column :totals, :device, :string
  	add_column :totals, :where_online, :string
  end
end
