# frozen_string_literal: true

require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
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
end
