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
  version '0.0.1'
# url ''
# author_url ''

  project_module :uploads do
     permission :manage_uploads, {:uploads => [:edit, :update]}, :require => :member
     permission :delete_uploads, {:uploads => [:destroy]}, :require => :member
     permission :create_uploads, {:uploads => [:new, :create]}, :require => :member
     permission :upload_files, {:uploads => [:addFiles, :downloadAll]}, :require => :loggedin
     permission :view_upload_forms  , {:uploads => [:index, :show]}
  end

  menu :project_menu, :uploads, {:controller => 'uploads', :action => 'index'},   {:caption => 'Uploads', :after => :activity, :param => :project_id }


end

Redmine::Search.map do |search|
  search.register :upload_forms
end

Redmine::Activity.map do |activity|
  activity.register :upload_forms
end
