# frozen_string_literal: true

require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  def setup
    @user = users :lena
    @user.activation_token = User.new_token
    @user.reset_token = User.new_token
  end

  test 'account_activation' do
    mail = UserMailer.with(user: @user).account_activation
    assert_equal 'Account activation', mail.subject
    assert_equal [@user.email], mail.to
    assert_equal ['noreplay@example.com'], mail.from
    assert_match 'Hi', mail.body.encoded
  end

  test 'password_reset' do
    mail = UserMailer.with(user: @user).password_reset
    assert_equal 'Password reset', mail.subject
    assert_equal [@user.email], mail.to
    assert_equal ['noreplay@example.com'], mail.from
    assert_match 'Password reset', mail.body.encoded
    assert_match CGI.escape(@user.email), mail.body.encoded
  end
end
