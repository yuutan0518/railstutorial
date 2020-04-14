require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title,         "Contact"
    assert_equal full_title("Help"), "Contact"
  end
end