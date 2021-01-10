# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users :andrey
    @dima = users :dima
    @not_admin = users :not_admin
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
    log_in_as @dima

    assert_not @not_admin.admin?

    patch user_path(@not_admin), params: {
      user: {
        password: 'password',
        password_confirmation: 'password',
        admin: true
      }
    }

    assert_not @not_admin.reload.admin?
  end

  test 'should redirect destroy when guest' do
    assert_no_difference 'User.count' do
      delete user_url(@user)
    end

    assert_redirected_to login_url
  end

  test 'should redirect destroy unless admin' do
    log_in_as @not_admin
    assert_not @not_admin.admin?

    assert_no_difference 'User.count' do
      delete user_url(@user)
    end

    assert_redirected_to root_url
  end

  test 'guest should redirect following' do
    get following_user_url(@user)

    assert_redirected_to login_url
  end

  test 'guest should redirect followers' do
    get followers_user_url(@user)

    assert_redirected_to login_url
  end

  test 'following' do
    log_in_as @dima
    get following_user_url(@user)

    assert_response :success
  end

  test 'followers' do
    log_in_as @dima
    get followers_user_url(@user)

    assert_response :success
  end

  test 'feed should have the right posts' do
    mama = users :mama
    papa = users :papa
    zaur = users :zaur


    mama.microposts.each do |post_following|
      # Posts from followed user
      assert papa.feed.include?(post_following)

      # Posts from self
      assert mama.feed.include?(post_following)
    end

    # Posts from unfollowed user
    papa.microposts.each do |post_unfollowed|
      assert_not zaur.feed.include?(post_unfollowed)
    end
  end
end
