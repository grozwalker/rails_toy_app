# frozen_string_literal: true

require 'test_helper'

class AuthConcernTest < ActionView::TestCase
  include Authentification

  def setup
    @user = users :andrey
    remember(@user)
  end

  test 'current_user return right user when session is nil' do
    assert_equal @user, current_user
    assert logged_in?
  end

  test 'current user return nil when remember digest is wrong' do
    @user.update!(remember_digest: User.digest(User.new_token))

    assert_nil current_user
  end
end
