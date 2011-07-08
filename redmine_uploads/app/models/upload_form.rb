class UploadForm < ActiveRecord::Base
  unloadable
  belongs_to :project, :polymorphic => true
  has_many :attachments, :foreign_key => "container_id"
  acts_as_attachable :delete_permission => :manage_documents
  acts_as_activity_provider :find_options => {:include => :project}
end
