require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @micropost = microposts :one
  end

  test 'valid user' do
    assert @micropost.valid?
  end

  test 'user require' do
    @micropost.user = nil

    assert_not @micropost.valid?
  end

  test 'content mast be present' do
    @micropost.content = ''

    assert_not @micropost.valid?
  end

  test 'content mast be less then 150' do
    @micropost.content = 'a' * 141

    assert_not @micropost.valid?
  end
end
