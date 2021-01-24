require 'test_helper'

class ActionlogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @actionlog = actionlogs(:one)
  end

  test "should get index" do
    get actionlogs_url
    assert_response :success
  end

  test "should get new" do
    get new_actionlog_url
    assert_response :success
  end

  test "should create actionlog" do
    assert_difference('Actionlog.count') do
      post actionlogs_url, params: { actionlog: { article_id_id: @actionlog.article_id_id, kind: @actionlog.kind, memo: @actionlog.memo } }
    end

    assert_redirected_to actionlog_url(Actionlog.last)
  end

  test "should show actionlog" do
    get actionlog_url(@actionlog)
    assert_response :success
  end

  test "should get edit" do
    get edit_actionlog_url(@actionlog)
    assert_response :success
  end

  test "should update actionlog" do
    patch actionlog_url(@actionlog), params: { actionlog: { article_id_id: @actionlog.article_id_id, kind: @actionlog.kind, memo: @actionlog.memo } }
    assert_redirected_to actionlog_url(@actionlog)
  end

  test "should destroy actionlog" do
    assert_difference('Actionlog.count', -1) do
      delete actionlog_url(@actionlog)
    end

    assert_redirected_to actionlogs_url
  end
end
