class AddCustomStatusCommentToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :custom_status_comment, :text
  end
end
