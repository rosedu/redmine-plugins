module Plugin
  module Uploads
    class ViewHooks < Redmine::Hook::ViewListener
      def view_layouts_base_html_head(context={})
        stylesheet_link_tag 'redmine_uploads', :plugin => 'redmine_uploads'
      end
    end
  end
end
~                                                                               
~                                                                               
~              
