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

  test 'login with valid data' do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: 'test' } }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path
  end
end
