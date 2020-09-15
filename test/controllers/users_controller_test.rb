# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.new(
      name: 'Example User',
      email: 'user@example.com',
      password: 'foobar',
      password_confirmation: 'foobar'
    )

    @user.save!
  end

  test 'should get new' do
    get signup_url
    assert_response :success
  end

  test 'show' do
    get user_url(@user)
    assert_response :success
  end
end
