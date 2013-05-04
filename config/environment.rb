# Load the rails application
require File.expand_path('../application', __FILE__)

	OFFICE_IP = "113.57.185.58" #"125.220.240.85" 
	FRESH_TIME = 120
	CUSTOM_DOMAIN = "http://labs.mothin.com"
	CUSTOM_ROOT_PATH = CUSTOM_DOMAIN
	CUSTOM_STATUS_ROOT_PATH = CUSTOM_DOMAIN #status页面不再是首页的时候... +/status
# Initialize the rails application
Mothinlab::Application.initialize!
