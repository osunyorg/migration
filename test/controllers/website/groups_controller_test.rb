require "test_helper"

class Website::GroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @website_group = website_groups(:one)
  end

  test "should get index" do
    get website_groups_url
    assert_response :success
  end

  test "should get new" do
    get new_website_group_url
    assert_response :success
  end

  test "should create website_group" do
    assert_difference("Website::Group.count") do
      post website_groups_url, params: { website_group: { name: @website_group.name, strategy_klass: @website_group.strategy_klass, website_id: @website_group.website_id } }
    end

    assert_redirected_to website_group_url(Website::Group.last)
  end

  test "should show website_group" do
    get website_group_url(@website_group)
    assert_response :success
  end

  test "should get edit" do
    get edit_website_group_url(@website_group)
    assert_response :success
  end

  test "should update website_group" do
    patch website_group_url(@website_group), params: { website_group: { name: @website_group.name, strategy_klass: @website_group.strategy_klass, website_id: @website_group.website_id } }
    assert_redirected_to website_group_url(@website_group)
  end

  test "should destroy website_group" do
    assert_difference("Website::Group.count", -1) do
      delete website_group_url(@website_group)
    end

    assert_redirected_to website_groups_url
  end
end
