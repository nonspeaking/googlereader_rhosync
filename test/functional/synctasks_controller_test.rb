require 'test_helper'

class SynctasksControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:synctasks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create synctask" do
    assert_difference('Synctask.count') do
      post :create, :synctask => { }
    end

    assert_redirected_to synctask_path(assigns(:synctask))
  end

  test "should show synctask" do
    get :show, :id => synctasks(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => synctasks(:one).id
    assert_response :success
  end

  test "should update synctask" do
    put :update, :id => synctasks(:one).id, :synctask => { }
    assert_redirected_to synctask_path(assigns(:synctask))
  end

  test "should destroy synctask" do
    assert_difference('Synctask.count', -1) do
      delete :destroy, :id => synctasks(:one).id
    end

    assert_redirected_to synctasks_path
  end
end
