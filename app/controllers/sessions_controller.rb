class SessionsController < ApplicationController  
  def new
    # Stuff to display on the login-page.
    redirect_to CUSTOM_DOMAIN if current_user
  end
  
  def create
    auth = request.env['omniauth.auth']
 
    # Find an authentication or create an authentication
    @authentication = Authentication.find_with_omniauth(auth)
    if @authentication.nil?
      # If no authentication was found, create a brand new one here
      @authentication = Authentication.create_with_omniauth(auth)
    end
 
    if signed_in?
      if @authentication.user == current_user
        # User is signed in so they are trying to link an authentication with their
        # account. But we found the authentication and the user associated with it 
        # is the current user. So the authentication is already associated with 
        # this user. So let's display an error message.
        redirect_to CUSTOM_DOMAIN, notice: "You have already linked this account" 
      else
        # The authentication is not associated with the current_user so lets 
        # associate the authentication
        @authentication.user = current_user
        @authentication.save
        
        redirect_to CUSTOM_DOMAIN, notice: "Account successfully authenticated"
      end
    else # no user is signed_in
      if @authentication.user.present?
        # The authentication we found had a user associated with it so let's 
        # just log them in here
        self.current_user = @authentication.user
        redirect_to CUSTOM_DOMAIN, notice: "Signed in!"
      else
        # The authentication has no user assigned and there is no user signed in
        # Our decision here is to create a new account for the user
        # But your app may do something different (eg. ask the user
        # if he already signed up with some other service)
        if @authentication.provider == 'identity'
          u = User.find(@authentication.uid)
          # If the provider is identity, then it means we already created a user
          # So we just load it up
        else
          # otherwise we have to create a user with the auth hash
          u = User.create_with_omniauth(auth)
          # NOTE: we will handle the different types of data we get back
          # from providers at the model level in create_with_omniauth
          #weibo 或者 github第一次验证加上一些资料
          if  @authentication.provider == "weibo"
            u.nick = auth[:info][:nickname]   
            u.avatar = auth[:info][:image]
            u.weibo = auth[:info][:urls][:Weibo]
          end
          if @authentication.provider == "github"
            u.github = auth[:info][:urls][:GitHub]
            u.avatar = auth[:info][:image] unless u.avatar
            u.website = auth[:info][:urls][:Blog]
          end
          u.save
        end
        # We can now link the authentication with the user and log him in
        u.authentications << @authentication
        u.recodes_init

        
        self.current_user = u
        redirect_to CUSTOM_DOMAIN, notice: "Welcome to The app!"

      end
    end
  end
  
  def destroy
    self.current_user = nil
    redirect_to CUSTOM_DOMAIN, notice: "Signed out!"
  end
  
  def failure  
    redirect_to CUSTOM_DOMAIN + '/login', alert: "Authentication failed, please try again."  
  end
end