# frozen_string_literal: true

require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
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

  test 'user valid information' do
    get signup_path

    assert_difference 'User.count', 1 do
      post users_path params: { user: {
        name: 'Foobar',
        email: 'foobar@example.com',
        password: 'foobar',
        password_confirmation: 'foobar'
      } }
    end

    follow_redirect!
    assert_template 'users/show'
    assert_select 'div.alert-success'

    assert logged_in?
  end
end
