require 'redmine'

Redmine::Plugin.register :redmine_feedbacks do
  name 'Redmine Feedback plugin'
  author 'Cristiana Voicu'
  description 'This is a feedback plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
  permission :feedbacks, { :feedbacks => [:index]}, :public =>true
  menu :project_menu, :feedbacks, { :controller => 'feedbacks', :action => 'index' }, 
	{ :caption => 'Feedbacks', :after => :activity, :param => :project_id}
end
