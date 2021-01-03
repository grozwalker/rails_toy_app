# frozen_string_literal: true

require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users :mama
  end

  # rubocop:disable Metrics/BlockLength
  test 'password reset' do
    # Get pass reset path
    get new_password_reset_url

    assert_template 'password_resets/new'
    assert_select 'input[name=?]', 'password_reset[email]'

    # Invalid email
    post password_resets_path, params: {
      password_reset: {
        email: 'invalid'
      }
    }
    assert_not flash.empty?
    assert_template 'password_resets/new'

    # Vaild email
    post password_resets_path, params: {
      password_reset: {
        email: @user.email
      }
    }

    assert @user.reload.reset_digest

    # Send mail
    assert_equal 1, ActionMailer::Base.deliveries.size

    assert_redirected_to root_url

    # Invalid password
    user = assigns(:user)

    get edit_password_reset_path(user.reset_token, email: 'wrong email')
    assert_redirected_to root_url

    user.toggle(:activated).save!

    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url

    user.toggle(:activated).save!

    # Right email, wrong token

    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url

    # Right email, right token
    get edit_password_reset_path(user.reset_token, email: user.email)

    assert_template 'password_resets/edit'
    assert_select 'input[name=email][type=hidden][value=?]', user.email

    # Invalid password & confirmation
    patch password_reset_path(user.reset_token), params: {
      email: user.email,
      user: {
        password: 'password',
        password_confirmation: 'wrong'
      }
    }
    assert_select 'div#error_explanation'

    # Empty password
    patch password_reset_path(user.reset_token), params: {
      email: user.email,
      user: {
        password: '',
        password_confirmation: ''
      }
    }
    assert_select 'div#error_explanation'

    # Valid password & confirmation
    patch password_reset_path(user.reset_token), params: {
      email: user.email,
      user: {
        password: 'password',
        password_confirmation: 'password'
      }
    }

    assert user_logged_in?
    assert_redirected_to user
  end
  # rubocop:enable Metrics/BlockLength

  test 'expired token' do
    get new_password_reset_url

    post password_resets_path, params: {
      password_reset: {
        email: @user.email
      }
    }

    user = assigns(:user)

    user.update!({ reset_sent_at: 3.hours.ago })

    patch password_reset_path(user.reset_token), params: {
      email: user.email,
      user: {
        password: 'password',
        password_confirmation: 'password'
      }
    }

    assert_response :redirect
    follow_redirect!
    assert_match(/expired/i, response.body)
  end
end
