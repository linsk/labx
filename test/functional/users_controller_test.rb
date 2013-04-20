require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: { avatar: @user.avatar, birthday: @user.birthday, city: @user.city, constellation: @user.constellation, dribbble: @user.dribbble, email: @user.email, github: @user.github, graduation: @user.graduation, jointime: @user.jointime, name: @user.name, nick: @user.nick, phonecall: @user.phonecall, qq: @user.qq, role: @user.role, slogan: @user.slogan, twitter: @user.twitter, website: @user.website, weibo: @user.weibo, weixin: @user.weixin }
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    put :update, id: @user, user: { avatar: @user.avatar, birthday: @user.birthday, city: @user.city, constellation: @user.constellation, dribbble: @user.dribbble, email: @user.email, github: @user.github, graduation: @user.graduation, jointime: @user.jointime, name: @user.name, nick: @user.nick, phonecall: @user.phonecall, qq: @user.qq, role: @user.role, slogan: @user.slogan, twitter: @user.twitter, website: @user.website, weibo: @user.weibo, weixin: @user.weixin }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end
end
