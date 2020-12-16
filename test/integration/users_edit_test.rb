# frozen_string_literal: true

require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users :andrey
  end

  test 'unsuccessfull edit' do
    log_in_as @user

    get edit_user_path(@user)
    assert_template 'users/edit'

    patch user_path(@user), params: {
      user: {
        name: 'test',
        email: 'invalid@email',
        password: 'foopass',
        password_confirmation: 'barpass'
      }
    }
    assert_template 'users/edit'
  end

  test 'successfull edit' do
    log_in_as @user

    get edit_user_path(@user)
    assert_template 'users/edit'

    name = 'test'
    email = 'test@test.ru'
    patch user_path(@user), params: {
      user: {
        name: name,
        email: email,
        password: '',
        password_confirmation: ''
      }
    }

    assert_not flash.empty?
    assert_redirected_to @user

    @user.reload

    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test 'redirect to edit page frendly redirect' do
    get edit_user_path(@user)
    log_in_as @user

    assert_redirected_to edit_user_path(@user)
  end
end
