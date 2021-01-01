# frozen_string_literal: true

require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users :andrey
  end

  test 'login with invalid data' do
    get login_path
    assert_template 'sessions/new'

    params = { session: { email: 'test@test.ru', password: 'invalid ' } }
    post login_path, params: params

    assert_template 'sessions/new'

    assert_not flash.empty?

    get root_path

    assert flash.empty?
  end

  test 'login with valid information followed by logout' do
    get login_path
    post login_path, params: { session: { email:
    @user.email,
                                          password: 'test' } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path

    delete logout_path

    # Simulate a user clicking logout in a second window
    delete logout_path

    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path,
                  count: 0
  end

  test 'login with valid email/invalid password' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: @user.email,
                                          password: 'invalid' } }
    assert_not is_logged_in?
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test 'login with remember me' do
    log_in_as @user, remember_me: '1'

    assert_equal cookies[:remember_token], assigns(:user).remember_token
  end

  test 'login without remember me' do
    log_in_as @user, remember_me: '1'
    log_in_as @user, remember_me: '0'

    # raise .inspect

    assert_empty cookies[:remember_token]
  end
end
