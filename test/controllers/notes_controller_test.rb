require "test_helper"

class NotesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get notes_home_url
    assert_response :success
  end
end
