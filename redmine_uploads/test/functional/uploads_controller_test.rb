require File.dirname(__FILE__) + '/../test_helper'

require 'uploads_controller'

class UploadsController; def rescue_action(e) raise e end; end

class UploadsControllerTest < ActionController::TestCase
  fixtures :projects, :users, :roles, :members, :member_roles, :enabled_modules, :upload_forms, :attachments

  #Default initializations
  def setup
    @controller = UploadsController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    User.current = nil
  end 

  #Routing tests
  def test_index_routing
    assert_routing(
     {:method => :get, :path => '/projects/567/uploads'}, :controller => 'uploads', :action => 'index', :project_id => '567'
    )
  end  

  def test_new_routing
    assert_routing(
      {:method => :get, :path => '/projects/567/uploads/new'},
      :controller => 'uploads', :action => 'new', :project_id => '567'
    )

    assert_recognizes(
      {:controller => 'uploads', :action => 'create', :project_id => '567'},
      {:method => :post, :path => '/projects/567/uploads'}
    )
  end

  def test_edit_routing
    assert_routing(
      {:method => :get, :path => '/uploads/22/edit'},
      :controller => 'uploads', :action => 'edit', :id => '22'
    )
  end

  def test_update_routing
    assert_recognizes(
      {:controller => 'uploads', :action => 'update', :id => '567'},
      {:method => :put, :path => '/uploads/567'}
    )
  end

  def test_show_routing
    assert_routing(
      {:method => :get, :path => '/uploads/22'},
      :controller => 'uploads', :action => 'show', :id => '22'
    )
  end
 
  def test_destroy_routing
    assert_recognizes(
      {:controller => 'uploads', :action => 'destroy', :id => '567'},
      {:method => :delete, :path => '/uploads/567'}
    )
  end

  def test_add_file_routing
   assert_routing(
      {:method => :post, :path => '/uploads/22/add_file'},
      :controller => 'uploads', :action => 'add_file', :id => '22'
   )
  end

  def test_download_all_routing
   assert_routing(
      {:method => :get, :path => '/uploads/22/download_all'},
      :controller => 'uploads', :action => 'download_all', :id => '22'
    )
  end

 def test_destroy
#    puts Documents.all.inspect
#    puts "----------------------------"
#    puts UploadForm.all.inspect
    
#    u = UploadForm.find 1    
#    u.project = Project.find 1
#    u.save
#     puts roles(:roles_001).inspect

 
#    @request.session[:user_id] = 1
#    @resp = delete :destroy, :id => 1
#    puts @response.to_s
#    assert_redirected_to 'projects/ecookbook/uploads'
#    assert_nil UploadForm.find_by_id(1)
  end

  def test_index
#    puts Project.all.inspect
    @request.session[:user_id] = 1
    @pr = Project.find 1
   # @pr.active = true
#     puts "Context :" + @pr.active?.to_s
#     puts "Con :" + @pr.allows_to?(:view_upload_forms).to_s
  
    puts enabled_modules(:enabled_modules_026).inspect

    @resp = (get :index, :project_id => 'ecookbook')
 
    @us = User.current
    puts "-------------------"
    puts @us.allowed_to?(:view_upload_forms, @pr).to_s
    puts @us.allowed_to?(:view_documents, @pr).to_s
    puts User.current
    puts "-------------------"

    assert_response :success
    assert_template 'index'
  end

  def test_truth
    assert true
  end
end
