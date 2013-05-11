class LogsController < ApplicationController

	def log

		must_loged_in
		@pre_log = current_user.logs.last #|| current_user.logs.create(:where_online => from_here,:device => user_device) #一般登录完会跳转到status,在那边创建？
		create_new_total = nil

		#离线过的话 #判断在线地点 #TODO设备是否改变 	#fresh_time可以加上一些容差情况。 
		if Time.now - @pre_log.updated_at > fresh_time || @pre_log.where_online != from_here 

		#如果离线过，就记录上一次的最后一条记录、统计上一次时间
			@total = current_user.totals.last #|| current_user.totals.create(:start => @pre_log.updated_at)
			@total.end = @pre_log.updated_at
			@total.counter = @total.end - @total.start
			@total.where_online = @pre_log.where_online
			@total.device = @pre_log.device
			@total.save

			create_new_total = true
			current_user.update_attributes(:custom_status_comment => nil) if from_here == "office" #如果回到office,自动清空自定义状态说明
		end
				#TODO 换成update #ToDo 减少创建log记录
		@log = current_user.logs.create(:where_online => from_here,:device => user_device) #TODO :where_online
		current_user.totals.create(:start => @log.updated_at) if create_new_total
	end

	def checkin_from_chromeextension
		self.log
	end

	def status
		@users = User.all
	end

	def report
	
	end

end