# frozen_string_literal: true

require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test 'user invalid information' do
    get signup_path

    assert_no_difference 'User.count' do
      post users_path params: { user: {
        name: 'Foobar',
        email: 'foobar@invalid',
        password: 'foo',
        password_confirmation: 'foo'
      } }
    end

    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test 'user valid information with account activation' do
    get signup_path

    assert_difference 'User.count', 1 do
      post users_path params: { user: {
        name: 'Foobar',
        email: 'foobar@example.com',
        password: 'foobar',
        password_confirmation: 'foobar'
      } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size

    user = assigns(:user)

    assert_not user.activated?

    # Log in before activation
    log_in_as user
    assert_not user_logged_in?

    # Wrong token
    get edit_account_activation_url('wrong token', email: user.email)
    assert_not user_logged_in?

    # Wrong email
    get edit_account_activation_url(user.activation_token, email: 'wrong email')
    assert_not user_logged_in?

    # Correct info
    get edit_account_activation_url(user.activation_token, email: user.email)
    # raise user.reload.inspect
    assert user.reload.activated?

    follow_redirect!
    assert_template 'users/show'
    assert_select 'div.alert-success'

    assert user_logged_in?
  end
end
