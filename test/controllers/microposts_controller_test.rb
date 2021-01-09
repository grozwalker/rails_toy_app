# frozen_string_literal: true

require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @micropost = microposts :two
  end

  test 'guest cannot create micropost' do
    assert_no_difference 'Micropost.count' do
      post microposts_url,
           params: {
             micropost: {
               content: 'test'
             }
           }
    end

    assert_redirected_to login_url
  end

  test 'guest cannot destroy micropost' do
    assert_no_difference 'Micropost.count' do
      delete micropost_url(@micropost),
             params: {
               micropost: {
                 content: 'test'
               }
             }
    end

    assert_redirected_to login_url
  end

  test 'redirect when destroy foreign micropost' do
    user = users :dima
    log_in_as(user)

    assert_no_difference 'Micropost.count' do
      delete micropost_url(@micropost)
    end

    assert_redirected_to root_url
  end
end
