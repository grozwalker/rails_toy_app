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
    assert logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path

    delete logout_path
    assert_not logged_in?
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
    assert_not logged_in?
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
end