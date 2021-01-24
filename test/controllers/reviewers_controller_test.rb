require 'test_helper'

class ReviewersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reviewer = reviewers(:one)
  end

  test "should get index" do
    get reviewers_url
    assert_response :success
  end

  test "should get new" do
    get new_reviewer_url
    assert_response :success
  end

  test "should create reviewer" do
    assert_difference('Reviewer.count') do
      post reviewers_url, params: { reviewer: { affiliation: @reviewer.affiliation, article_id: @reviewer.article_id, email: @reviewer.email, name: @reviewer.name } }
    end

    assert_redirected_to reviewer_url(Reviewer.last)
  end

  test "should show reviewer" do
    get reviewer_url(@reviewer)
    assert_response :success
  end

  test "should get edit" do
    get edit_reviewer_url(@reviewer)
    assert_response :success
  end

  test "should update reviewer" do
    patch reviewer_url(@reviewer), params: { reviewer: { affiliation: @reviewer.affiliation, article_id: @reviewer.article_id, email: @reviewer.email, name: @reviewer.name } }
    assert_redirected_to reviewer_url(@reviewer)
  end

  test "should destroy reviewer" do
    assert_difference('Reviewer.count', -1) do
      delete reviewer_url(@reviewer)
    end

    assert_redirected_to reviewers_url
  end
end
