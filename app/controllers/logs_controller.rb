Class LogsController < ApplicationController

	def log
		@log = @user.logs.create(params[:where] => where)
	end

end