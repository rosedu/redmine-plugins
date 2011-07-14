require 'redmine'


Redmine::Plugin.register :redmine_uploads do
  name 'Uploads plugin for Redmine'
  author 'Tudor Cornea'
  description 'This is a plugin for Redmine'
  version '0.0.1'

#  permission :uploads, {:uploads => [:show_uploads, :upload_files]}, :public => false

  project_module :uploads do
     permission :view_uploads  , :uploads => [:index, :show], :require => :member
     permission :create_uploads, :uploads => [:new, :edit, :create, :destroy, :uploadFile], :require => :member
  end

  menu :project_menu, :uploads, {:controller => 'uploads', :action => 'index'},   {:caption => 'Uploads', :after => :activity, :param => :project_id }


#  activity_provider :uploads, :default => false, :class_name => ['Upload', 'UserUploads']


end
