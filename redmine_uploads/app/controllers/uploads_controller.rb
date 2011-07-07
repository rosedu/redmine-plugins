class UploadsController < ApplicationController
  unloadable
  before_filter :find_project

  def index
     @up_forms = UploadForm.find :all, :conditions => "project_id = #{@project.id}"

#    render :text => "Hello world"
#    logger.info "==================== Start ======================"
#    logger.debug "The object is #{@project}"
#    RAILS_DEFAULT_LOGGER.debug @project
#    return render :text => "The object is" +  @uploads.to_s
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
#    @upload = Upload.find(params[:id]) 
#    render :text => "Hello World"
#    @data_files = UploadForm.find(params[:id]).data_files
#   render :text =>  @data_files.inspect 
#    render :text => "Hello"

   @upload = UploadForm.find(params[:id])
#   @upload_form = UploadForm.find(params[:id].to_i)
#   render :text => params.inspect
#   render :text => @upload_form.to_s  
   end

  def new
  end
 
  def destroy
        @upload = UploadForm.find(params[:id])
        @upload.destroy
	redirect_to :action => "index", :project_id => @project
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
     redirect_to :action => "index", :project_id => @project
   end 
  end
 
  private

    def find_project
        @project = Project.find(params[:project_id])
    end
 
end
