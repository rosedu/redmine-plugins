class UploadsController < ApplicationController
 #_
#  before_filter :find_project_by_project_id
#  before_filter :authorize

#  default_search_scope :uploads  
#  default_search_scope :documents
  menu_item :uploads

  helper :sort
  include SortHelper
#  model_object UploadForm
#  model_object Document

  before_filter :find_project

#  before_filter :find_project, :only => [:index, :new]
#  before_filter :find_model_object, :except => [:index, :new] 
#  before_filter :find_project_from_association, :except => [:index, :new]
#  before_filter :authorize
################

#  model_object Upload
#  before_filter :find_project_by_project_id
#  before_filter :find_model_object, :except => [:index, :show, :new]
#  before_filter :find_project_from_association, :except => [:index, :show, :new]
#  before_filter :authorize_global

  helper :attachments

#############


  def index

     @up_forms = UploadForm.find :all, :conditions => "project_id = #{@project.id}"
#    render :text => "Hello world"
#    logger.info "==================== Start ======================"
#    logger.debug "The object is #{@project}"
#    RAILS_DEFAULT_LOGGER.debug @project
#     render :text => @up_forms.inspect

  end

  def uploadFile
    post = DataFile.save(params[:upload]) 
    render :text => "File has been uploaded successfully"
  end

   def cleanup
    File.delete("#{RAILS_ROOT}/dirname/#{@filename}") 
            if File.exist?("#{RAILS_ROOT}/dirname/#{@filename}")
            end
   end

  def show 

#     render :text => "Helllo"
#    render :text => @project.to_s
#    render :text => params.inspect
    
    sort_init 'filename', 'asc'
    sort_update 'author' => "#{User.table_name}.firstname",
                'filename' => "#{Attachment.table_name}.filename",
                'created_on' => "#{Attachment.table_name}.created_on",
                'size' => "#{Attachment.table_name}.filesize"

   @upload_form = UploadForm.find(params[:id])
 
   @files = @upload_form.attachments.all(:order => sort_clause, :joins => "LEFT JOIN users ON users.id = attachments.author_id")
   
  end

  def edit
   @upload = UploadForm.find(params[:id])
  end


  def new
  end
 
  def destroy
        @upload = UploadForm.find(params[:id])
        @upload.destroy
	redirect_to :action => "index", :project_id => @project
  end


  def addFiles
    #TODO change hard_coded number
    container = UploadForm.find(11)
    attachments = Attachment.attach_files(container, params[:attachments])
#    render_attachment_warning_if_needed(container)

    if !attachments.empty? && !attachments[:files].blank? && Setting.notified_events.include?('file_added')
 #     Mailer.deliver_attachments_added(attachments[:files])
    end
#    redirect_to project_files_path(@project)
 end


  def addFiles2


#      render :text => params[1.to_s][:description]
#      render :text => params[:1].inspect
#      render :text => params[:attachments][1.to_s].inspect
#      render  :text => params[:attachments]["1"][:file].class

#      render :text => params[:id]

      @attach = Attachment.new
      @attach.container_id = params[:id]
      @attach.container_type = "UploadForm"      
      @attach.file = params[:attachments]["1"][:file]
      @attach.author_id = User.current.id
      @attach.description = params[:attachments]["1"][:description] 

      @attach.container = UploadForm.find(11)
#      @attach.attach_files(@project, params[:attachments]) 

#     redirect_to :action => "index", :project_id => @project
  
      if @attach.save!
          flash[:notice] = "File(s) uploaded successfully!"
          redirect_to :action => "index", :project_id => @project
      else
          flash.now[:error] = "File(s) failed to upload!"
      end
#      rescue  
#          flash[:warning] = "File Validation failed! Did you forget to specify a file?"
#          redirect_to :action => "index", :project_id => @project
 	  #render :action => "show"
     

  end

  def create
#    render :text => params.inspect
#    render :text =>  params[:project_id]
#    render :text => "Hello"
    @up_form = UploadForm.new

    @up_form.title = params[:upload][:title]    
    @up_form.description = params[:upload][:description]
    @up_form.created_on = Time.now
    @up_form.project_id = params[:proj_id].to_i    

    if  @up_form.save!
       flash[:notice] = "Upload form created !"
       redirect_to :action => "index"
    else   
       flash.now[:error] = "Upload form was not created !"
    end
  end

  def update
    @upload = UploadForm.find(params[:id])
      
   if request.post? and @upload.update_attributes(params[:upload])
       
     flash[:notice] =l(:notice_successful_update)
     redirect_to :action => "show", :id => params[:id], :project_id => @project
   end 
  end
 
  private


 def find_project2
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end


  def find_project
    if params.has_key? :project_id
      @project = Project.find(params[:project_id])
    elsif params.has_key? :id 
      @project = Project.find(UploadForm.find(params[:id]).project_id)
    else 
      render_404
    end
  end
 
end
