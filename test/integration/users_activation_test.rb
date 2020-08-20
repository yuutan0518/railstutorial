require 'test_helper'

class UsersActivationTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @activate_user = users(:michael)
    @non_activate_user = users(:yamada)
  end


  test "index only activated user" do

    log_in_as(@activate_user)
    get users_path
    assert_select "a[href=?]", user_path(@activate_user)
    assert_select "a[href=?]", user_path(@non_activate_user), count: 0
    
  end

  test "show only activated user" do
    log_in_as(@activate_user)
    get user_path(@activate_user)
    get user_path(@non_activate_user)
  end




end
