# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      name: 'Example User',
      email: 'user@example.com',
      password: 'foobar',
      password_confirmation: 'foobar'
    )
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'name should be present' do
    @user.name = ' '
    assert_not @user.valid?
  end

  test 'name should not to be long' do
    @user.name = 'q' * 51
    assert_not @user.valid?
  end

  test 'email should be present' do
    @user.email = ' '
    assert_not @user.valid?
  end

  test 'email should not to be long' do
    @user.email = "#{'a' * 250}example.com"
    assert_not @user.valid?
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]

    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test 'email validation should reject invalid addresses' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.сom foo@bar+baz.com]

    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test 'duplicate email is invalid' do
    dup_user = @user.dup
    @user.save

    assert_not dup_user.valid?
  end

  test 'email save in lowercase' do
    multi_case_email = 'FoOBaR@EXAMPLE.com'
    @user.email = multi_case_email
    @user.save!

    @user.reload

    assert_equal multi_case_email.downcase, @user.email
  end

  test 'password should be present (nonblank)' do
    @user.password = @user.password_confirmation = ' ' * 6
    assert_not @user.valid?
  end

  test 'password should have a minimum length' do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end

  test 'authenticated? return false when remember digest nil' do
    assert_not @user.authenticated?(:remember, '')
  end

  test 'destroy user should destroy micropost' do
    @user.save!
    @user.microposts.create(content: 'test')

    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test 'follow and unfollow user' do
    kirill = users :kirill
    halug = users :halug

    assert_not kirill.following? halug

    kirill.follow halug
    assert kirill.following? halug
    assert halug.followers.include? kirill

    kirill.unfollow halug
    assert_not kirill.following? halug
  end
end
