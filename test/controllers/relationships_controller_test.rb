# frozen_string_literal: true

require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  test 'guest cant create' do
    assert_no_difference 'Relationship.count' do
      post relationships_url
    end

    assert_redirected_to login_url
  end

  test 'guest cant destroy' do
    assert_no_difference 'Relationship.count' do
      post relationships_url
    end

    assert_redirected_to login_url
  end

  test 'create' do
    user = users :ivan
    other = users :igor

    log_in_as user

    assert_difference 'user.following.count', 1 do
      post relationships_url, params: { followed_id: other.id }
    end
  end

  test 'destroy' do
    relationship = relationships :kurb_zaur
    user = relationship.follower

    log_in_as user

    assert_difference 'user.following.count', -1 do
      delete relationship_url(relationship)
    end
  end
end
