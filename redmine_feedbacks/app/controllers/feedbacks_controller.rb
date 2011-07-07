class FeedbacksController < ApplicationController
  unloadable

  before_filter :find_project
  def create
	  
	@feedback = Feedback.new(params[:feedback])
	@feedback.created_on = Time.now
	@feedback.project_id = params[:proj_id].to_i
	
	if @feedback.save
		flash[:notice] = 'Feedback created.'
		redirect_to :action => "index", :project_id => @project
	else 
		flash[:notice] = 'Feedback not created.'
		render :action => "new"
	end	
  end
  
  def index
	@feedbacks = Feedback.find(:all)
  end

  def new
	@feedback = Feedback.new
  end

  def show
	@feedback = Feedback.find(params[:id])
	@qtype =%w(yes/no multiple).include?(params[:type]) ? params[:type] : 'yes/no'
  end

  def destroy
    @feedback = Feedback.find(params[:id])
    @feedback.destroy
    redirect_to  :action => "index", :project_id =>@project
  end

  def edit
    @feedback = Feedback.find(params[:id]) 
    if request.post? and @feedback.update_attributes(params[:feedback])
      flash[:notice] = l(:notice_successful_update)
      redirect_to :action => 'show', :id => @feedback, :project_id => @project
    end
  end  

  def add_q
	@qtype = params[:type]
	render :text => @qtype
  end
  private
	def find_project
		@project = Project.find(params[:project_id])
	end
end
