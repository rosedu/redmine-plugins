class UploadsController < ApplicationController

  default_search_scope :uploadForms
  menu_item :upload_forms

# Include sort module
  helper :attachments
  helper :sort
  include SortHelper

  before_filter :find_project, :except => [:show, :destroy, :update, :lock, :edit]
  before_filter :find_upload_form, :only => [:show, :destroy, :update, :lock, :edit, :download_all]

   before_filter :authorize

  def download_all
 
   #If user is admin, he should see all the files 
   if User.current.admin
	   @files = @up_form.attachments.all(:joins => "LEFT JOIN users ON users.id = attachments.author_id")
   else
           @files = @up_form.attachments.all(:joins => "LEFT JOIN users ON users.id = attachments.author_id", :conditions => [ "author_id = ?", User.current.id ] )
   end

   #Gather the names of the files, separated by ' '
   file_names = @files.collect(&:disk_filename).join ' '
   current_timestamp = Time.new.to_time.to_i
   archive_name = "#{current_timestamp}_attachments.tar.gz"
    
   `cd files/ ; tar -cvzf #{archive_name} #{file_names}; cd ..;`    

   #Disabled streaming. The whole file will be loaded into server, and 
   #then sent
   send_file "files/#{archive_name}", :type => "application/x-gzip", :stream => false

   #Clean up after send
   `rm files/#{archive_name} ;`

#  redirect_to :show, :params => @up_form
  end 

  def index

    @up_forms = @project.upload_forms
#     @up_forms = UploadForm.find :all, :conditions => "project_id = #{@project.id}"
#    render :text => "Hello world"
#    logger.info "==================== Start ======================"
#    logger.debug "The object is #{@project}"
#    RAILS_DEFAULT_LOGGER.debug @project
#     render :text => @up_forms.inspect
  
#   if request.xhr?  
#      render :layout => false
#   end
   render :layout => false if request.xhr?

  end

   def cleanup
    File.delete("#{RAILS_ROOT}/dirname/#{@filename}") 
            if File.exist?("#{RAILS_ROOT}/dirname/#{@filename}")
            end
   end

  def show 

    sort_init 'filename', 'asc'
    sort_update 'author' => "#{User.table_name}.firstname",
                'filename' => "#{Attachment.table_name}.filename",
                'created_on' => "#{Attachment.table_name}.created_on",
                'size' => "#{Attachment.table_name}.filesize"

    @upload_form = UploadForm.find(params[:id])
   
    @my_files = @upload_form.attachments.all(:order => sort_clause, :joins => "LEFT JOIN users ON users.id = attachments.author_id", :conditions => [ "author_id = ?", User.current.id ] )

    if User.current.admin
      @show_files = @upload_form.attachments.all(:order => sort_clause, :joins => "LEFT JOIN users ON users.id = attachments.author_id")
    else
      @show_files = @my_files 
    end

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


  def add_file
    #TODO change hard_coded number
    container = UploadForm.find(params[:id])
    old_attachments = container.attachments.all(:conditions => ["author_id = ?", User.current.id] )
#    render :text => old_attachments.class
#    render :text => container.attachments.to_s
   
#    old_attachments.destroy
    old_attachments.each do |old_att|
      old_att.destroy
    end


    attachments = Attachment.attach_files(container, params[:attachments])

    redirect_to :back, :params => container

#    render_attachment_warning_if_needed(container)

#    if !attachments.empty? && !attachments[:files].blank? && Setting.notified_events.include?('file_added')
 #     Mailer.deliver_attachments_added(attachments[:files])
#    end
 #   render :text => request.inspect
#    redirect_to request.fullpath
 end


  def create
#    render :text => params.inspect
#    render :text =>  params[:project_id]
#    render :text => "Hello"
    @up_form = @project.upload_forms.build
    @document = @project.documents.build(params[:document])

    @up_form.title = params[:upload][:title]    
    @up_form.description = params[:upload][:description]
    @up_form.created_on = Time.now
#    @up_form.project = @project    

    if request.post? and @up_form.save
#       render_attachment_warning_if_needed(@up_form)
       flash[:notice] = l(:notice_successful_create)
       redirect_to :action => "index"
    else
      # redirect_to :back
#      flash[:error] = "Name required"
        render "new"
#        render :layout => false
#       redirect_to :action => "new", :project_id => @project
#       render_error({:message => "Name required", :status => 403})
#        render :text => @up_form.error_message
    end
#    rescue 
#       render_404
  end

  def update
   
   @upload = UploadForm.find(params[:id])
      
   if @upload.update_attributes(params[:upload])
       
     flash[:notice] =l(:notice_successful_update)
     redirect_to :action => "show", :id => params[:id]
   end 
  #TODO
  end
 
  private


 def find_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
#    render_404
  end

  def find_upload_form
   @up_form = UploadForm.find(params[:id])
   @project = @up_form.project
   rescue ActiveRecord::RecordNotFound
     render :text => "No permission"
  end
 
end
