require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      # post signup_path, params: {user: { name: "", email: "", password: "", password_cofirmation: ""}}

      post signup_path, params: { user: { name: "", 
                                  email: "user@invalid", 
                                  password: "foo", 
                                  password_cofirmation: "bar"} }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
    assert_select 'ul' do
      assert_select 'li', 'Name can\'t be blank'
      assert_select 'li', 'Email is invalid'
      # assert_select 'li', 'Password confirmation doesn\'t match Password'
      assert_select 'li', 'Password is too short (minimum is 6 characters)'
    end
    assert_select 'form[action="/signup"]'
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Test User",
                                         email: "test3@test.com",
                                         password: "foobar",
                                         password_cofirmation: "foobar"} }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?

  end
  
end
