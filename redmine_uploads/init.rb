require 'redmine'
require 'dispatcher'

Dispatcher.to_prepare do
  require_dependency 'project'
  require 'redmine_uploads/patch_redmine_classes'
  Project.send(:include, ::Plugin::Uploads::Project)
end

Redmine::Plugin.register :redmine_uploads do
  name 'Uploads plugin for Redmine'
  author 'Tudor Cornea'
  description 'Redmine plugin used for managing upload forms'
  version '0.0.2'
# url ''
# author_url ''

  project_module :uploads do
     permission :manage_upload_forms, {:uploads => [:edit, :update]}, :require => :member
     permission :delete_upload_forms, {:uploads => [:destroy]}, :require => :member
     permission :create_upload_forms, {:uploads => [:new, :create]}, :require => :member
     permission :view_upload_forms  , {:uploads => [:index, :show]}
     permission :delete_files, :require => :member
     permission :download_files, :require => :member     
     permission :download_all_files, {:uploads => [:download_all]}, :require => :loggedin
     permission :upload_files, {:uploads => [:add_file]}, :require => :loggedin
  end

  menu :project_menu, :uploads, {:controller => 'uploads', :action => 'index'},   {:caption => 'Uploads', :after => :activity, :param => :project_id }

  activity_provider :uploads, :default => false, :class_name => ['Uploads', 'UploadForms']
end

Redmine::Search.map do |search|
  search.register :upload_forms
end

Redmine::Activity.map do |activity|
  activity.register :upload_forms
end
