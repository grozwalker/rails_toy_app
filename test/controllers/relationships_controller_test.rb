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
end
