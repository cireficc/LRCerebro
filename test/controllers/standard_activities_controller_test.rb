require 'test_helper'

class StandardActivitiesControllerTest < ActionController::TestCase
  setup do
    @standard_activity = standard_activities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:standard_activities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create standard_activity" do
    assert_difference('StandardActivity.count') do
      post :create, standard_activity: {  }
    end

    assert_redirected_to standard_activity_path(assigns(:standard_activity))
  end

  test "should show standard_activity" do
    get :show, id: @standard_activity
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @standard_activity
    assert_response :success
  end

  test "should update standard_activity" do
    patch :update, id: @standard_activity, standard_activity: {  }
    assert_redirected_to standard_activity_path(assigns(:standard_activity))
  end

  test "should destroy standard_activity" do
    assert_difference('StandardActivity.count', -1) do
      delete :destroy, id: @standard_activity
    end

    assert_redirected_to standard_activities_path
  end
end
