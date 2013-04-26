class ApplicationController < ActionController::Base
  protect_from_forgery

  protected

  helper_method :current_user, :signed_in?,:in_where ,:must_logedin,:connected?

  # rescue_from CanCan::AccessDenied do |exception|
  #   redirect_to root_url, :alert => exception.message
  # end
 
  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end
 
  def signed_in?
    !!current_user
  end
 
  def current_user=(user)
    @current_user = user
    session[:user_id] = user.nil? ? user : user.id
  end

  def must_loged_in  #(:path,:notice)
    redirect_to root_path, notice: "Must be loged in." if !signed_in? 
  end

  def in_where
  	request.remote_ip != OFFICE_IP ? "online" :  "offline"
  end

#User connected provider? return booleam
  def connected?(provider)
    # Authentication.where("provider=? AND user_id=?", provider,session[:user_id]).count > 0
    Authentication.find_by_provider_and_user_id(provider,current_user)  
  end

end