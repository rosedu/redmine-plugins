class UploadForm < ActiveRecord::Base
#  unloadable
  belongs_to :project

#  attr_accessible :title, :description

  has_many :attachments, :foreign_key => "container_id", :as => 'container', :dependent => :destroy
#  acts_as_attachable :delete_permission => :manage_documents
#  acts_as_activity_provider :find_options => {:include => :project}
  
#  validates_presence_of :project, :title
#  validates_length_of :title, :maximum => 60
  acts_as_searchable :columns => ['title', "#{table_name}.title"], :include => :project

  acts_as_event :title => Proc.new {|o| "#{l(:label_upload)}: #{o.title}"},
                :author => Proc.new {|o| (a = o.attachments.find(:first, :order => "#{Attachment.table_name}.created_on ASC")) ? a.author : nil },
                :url => Proc.new {|o| {:controller => 'uploads', :action => 'show', :id => o.id}}


  validates_uniqueness_of :title
  validates_presence_of :project, :title
  validates_length_of :title, :maximum => 60
 
#  named_scope :visible, lambda {|*args| {:include => :project, :conditions => Project.allowed_to_condition(args.shift || User.current, :view_uploads, *args) } }


  def visible?(user=User.current)
    
    true #!user.nil? && user.allowed_to?(:view_documents, project)
  end

 def attachments_visible?(user=User.current)
    true
 end

 def attachments_deletable?(user=User.current)
    true
 end 

 def unsaved_attachments
   true
 end

  def after_initialize
    if new_record?
#      self.category ||= DocumentCategory.default
    end
  end

  def updated_on
    unless @updated_on
      a = attachments.find(:first, :order => 'created_on')
      @updated_on = (a && a.created_on) || created_on
    end
    @updated_on
  end
end
