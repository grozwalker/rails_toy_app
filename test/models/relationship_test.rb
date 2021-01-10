# frozen_string_literal: true

require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  def setup
    @relationship = relationships :lena_vera
  end

  test 'valid' do
    assert @relationship.valid?
  end

  test 'require follower id' do
    @relationship.follower = nil

    assert_not @relationship.valid?
  end

  test 'require followed id' do
    @relationship.followed = nil

    assert_not @relationship.valid?
  end
end
