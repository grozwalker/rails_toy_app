require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users :dima
    @not_admin = users :not_admin
  end

  test 'index as admin show pagination and delete link' do
    log_in_as @admin
    get users_path

    assert_template 'users/index'
    assert_select 'ul.pagination'

    first_page_of_users = User.paginate page:1

    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name

      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end

    assert_difference "User.count", -1 do
      delete user_url(@not_admin)
    end
  end

  test 'index as not admin' do
    log_in_as @not_admin

    get users_url()

    assert_select 'a', text: 'delete', count: 0
  end


end
