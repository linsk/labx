class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index 

    @users = User.all

    respond_to do |format|
      if current_user && current_user.admin?
        format.html # index.html.erb
        format.json { render json: @users }
      else
        format.html { redirect_to "/mshow/%s" % params[:id]  }
      end
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      if current_user #TODO if user_agent == mobile
        format.html { redirect_to "/mshow/%s" % params[:id]  }
      elsif !current_user
        format.html { redirect_to "/login",notice: 'please login'  }
      else
        format.html # show.html.erb
        format.json { render json: @user }
      end
      
    end
  end

  def mobileshow
    @user = User.find(params[:id])

    respond_to do |format|
      if current_user
        format.html # show.html.erb
        format.json { render json: @user }
      else
        format.html { redirect_to "/login",notice: 'please login'  }
      end
      
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  def set_graduation
    @user = User.find(params[:id])

    respond_to do |format|
      if current_user.admin? #TODO if user_agent == mobile
        format.html # show.html.erb
        format.json { render json: @user }
      else
        format.html { redirect_to root_path,notice: 'r u admin?'  }
      end
      
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user == current_user &&  @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy if @user == current_user || current_user.admin?

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def disconnect
    @auth = Authentication.find_by_provider_and_user_id(params[:provider],current_user)
    @auth.destroy if @auth
    redirect_to root_path, :notice => "Disconnect successfully"
  end
end
