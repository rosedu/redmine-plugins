require 'redmine'
require 'dispatcher'

#ActiveRecord::Base.send(:include, MyPlugin)

Dispatcher.to_prepare do
  require_dependency 'project'
  require 'redmine_uploads/patch_redmine_classes'
  Project.send(:include, ::Plugin::Uploads::Project)
end

Redmine::Plugin.register :redmine_uploads do
  name 'Uploads plugin for Redmine'
  author 'Tudor Cornea'
  description 'This is a plugin for Redmine'
  version '0.0.1'

#  permission :uploads, {:uploads => [:show_uploads, :upload_files]}, :public => false

  project_module :uploads do
     permission :manage_uploads, {:uploads => [:edit, :update]}, :require => :member
     permission :delete_uploads, {:uploads => [:destroy]}, :require => :member
     permission :create_uploads, {:uploads => [:new, :create]}, :require => :member
     permission :upload_files, {:uploads => [:uploadFile]}, :require => :loggedin
     permission :view_upload_forms  , {:uploads => [:index, :show]}
  end

  menu :project_menu, :uploads, {:controller => 'uploads', :action => 'index'},   {:caption => 'Uploads', :after => :activity, :param => :project_id }


#  activity_provider :uploads, :default => false, :class_name => ['Upload', 'UserUploads']
end

Redmine::Search.map do |search|
  search.register :upload_forms
#  search.register :workflows
end

