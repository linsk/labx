class LogsController < ApplicationController

	def log

		@log = current_user.logs.build(:where => in_where)
		@log.save
		#TODO (User-Agent iPhone Mac PC)
		#TODO 等total功能实现了,换成update
	end

	def status
		@users =User.all #find by my team
		#TODO 最后离开时间距离现在...多久
	end

end