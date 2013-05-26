module ApplicationHelper
	def display_notice_and_alert
    msg = ''
    msg << (content_tag :div, notice, :class => "alert alert-info mobile_alert") if notice
    msg << (content_tag :div, alert, :class => "alert alert-error mobile_alert") if alert
    sanitize msg
  end
end
