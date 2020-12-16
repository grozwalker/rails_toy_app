# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users :andrey
    @other_user = users :dima
  end

  test 'should get new' do
    get signup_url
    assert_response :success
  end

  test 'show' do
    get user_url(@user)
    assert_response :success
  end

  test 'index redirect for guest' do
    get users_path

    assert_redirected_to login_path
  end

  test 'not allow admin attribute update' do
    log_in_as @other_user
    assert_not @other_user.admin?

    patch user_path(@other_user), params: {
      user: {
        password: 'password',
        password_confirmation: 'password',
        admin: true
      }
    }

    assert_not @other_user.reload.admin?
  end
end
