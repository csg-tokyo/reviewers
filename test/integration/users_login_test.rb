require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:two)
  end

  test "login with valid information followed by logout" do
    do_login
    assert_redirected_to @user
    follow_redirect!
    #assert_template 'users/show'

    delete logout_path
    assert_not is_logged_in?
    #assert_redirected_to root_url
  end

  test "cannot login" do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: 'wrong-password' } }
    assert_response :success
  end

  test "can see users' list" do
    @user = users(:one)
    do_login
    get users_path
    assert_response :success
  end

  test "cannot see users' list" do
    do_login
    get users_path
    assert_redirected_to login_path
  end

  test "cannot create" do
    do_login
    get new_user_path
    assert_redirected_to login_path

    post users_path
    assert_redirected_to login_path
  end

  test "short password is not valid" do
    @user = users(:one)
    do_login
    assert false
  end

  test "can see users' page" do
    do_login
    get user_path(@user)
    assert_response :success
  end

  test "cannot see users' page" do
    do_login
    one_user = users(:one)
    get user_path(one_user)
    assert_redirected_to login_path

    get edit_user_path(one_user)
    assert_redirected_to login_path

    patch user_path(one_user)
    assert_redirected_to login_path

    delete user_path(one_user)
    assert_redirected_to login_path
  end

  def do_login
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: 'password' } }
    assert is_logged_in?
  end
end
