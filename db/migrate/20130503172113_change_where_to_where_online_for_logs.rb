class ChangeWhereToWhereOnlineForLogs < ActiveRecord::Migration
 def change
 		rename_column :logs, :where, :where_online
  end
end
