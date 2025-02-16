require "test_helper"

class CardCollectionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get card_collections_index_url
    assert_response :success
  end

  test "should get new" do
    get card_collections_new_url
    assert_response :success
  end

  test "should get create" do
    get card_collections_create_url
    assert_response :success
  end

  test "should get edit" do
    get card_collections_edit_url
    assert_response :success
  end

  test "should get update" do
    get card_collections_update_url
    assert_response :success
  end

  test "should get show" do
    get card_collections_show_url
    assert_response :success
  end
end
