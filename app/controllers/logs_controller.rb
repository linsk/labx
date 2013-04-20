Class LogsController < ApplicationController

	def log
		where = request.remote_ip == "220.220.220.220" ? "office" :  "online"
		@log = @user.logs.create(params[:where] => where)
	end

end