class UploadForm < ActiveRecord::Base
  unloadable
  belongs_to :project

  has_many :attachments, :foreign_key => "container_id", :as => 'container', :dependent => :destroy
  
  acts_as_attachable :delete_permission => :manage_uploads

  acts_as_searchable :columns => ['title', "#{table_name}.title"], :include => :project

  acts_as_event :title => Proc.new {|o| "#{l(:label_upload)}: #{o.title}"},
                :author => Proc.new {|o| (a = o.attachments.find(:first, :order => "#{Attachment.table_name}.created_on ASC")) ? a.author : nil },
                :url => Proc.new {|o| {:controller => 'uploads', :action => 'show', :id => o.id}}

  acts_as_activity_provider :find_options => {:include => :project}

# validates_uniqueness_of :title
  validates_presence_of :project, :title
  validates_length_of :title, :maximum => 60
 
   named_scope :visible, lambda {|*args| {:include => :project, :conditions => Project.allowed_to_condition(args.shift || User.current, :view_upload_forms, *args) } }
  def visible?(user=User.current)
   true 
  #  true #!user.nil? && user.allowed_to?(:view_documents, project)
  end

#TODO
 def attachments_visible?(user=User.current)
    true
 end

 def attachments_deletable?(user=User.current)
    true
 end 

  def updated_on
    unless @updated_on
      a = attachments.find(:first, :order => 'created_on')
      @updated_on = (a && a.created_on) || created_on
    end
    @updated_on
  end
end
