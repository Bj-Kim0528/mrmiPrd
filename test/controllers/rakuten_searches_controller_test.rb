require "test_helper"

class RakutenSearchesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get rakuten_searches_index_url
    assert_response :success
  end
end
