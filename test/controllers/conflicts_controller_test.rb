require 'test_helper'

class ConflictsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @conflict = conflicts(:one)
  end

  test "should get index" do
    get conflicts_url
    assert_response :success
  end

  test "should get new" do
    get new_conflict_url
    assert_response :success
  end

  test "should create conflict" do
    assert_difference('Conflict.count') do
      post conflicts_url, params: { conflict: { article_id: @conflict.article_id, user_id: @conflict.user_id } }
    end

    assert_redirected_to conflict_url(Conflict.last)
  end

  test "should show conflict" do
    get conflict_url(@conflict)
    assert_response :success
  end

  test "should get edit" do
    get edit_conflict_url(@conflict)
    assert_response :success
  end

  test "should update conflict" do
    patch conflict_url(@conflict), params: { conflict: { article_id: @conflict.article_id, user_id: @conflict.user_id } }
    assert_redirected_to conflict_url(@conflict)
  end

  test "should destroy conflict" do
    assert_difference('Conflict.count', -1) do
      delete conflict_url(@conflict)
    end

    assert_redirected_to conflicts_url
  end
end
