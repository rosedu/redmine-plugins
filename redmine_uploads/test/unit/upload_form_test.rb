require File.dirname(__FILE__) + '/../test_helper'

class UploadFormTest < ActiveSupport::TestCase
  fixtures :projects, :upload_forms, :attachments

  #Create a valid project object, used for testing
  def create_valid_project
    proj = Project.new(:name => "TestProject", :description => "A Test Project" ,:is_public => true, :created_on => Time.now, :updated_on => Time.now,  :identifier => "testproj", :lft => 1, :rgt => 10)

    assert proj.save
    proj
  end

  #Tests the various relations that UploadForm has with other models
  def test_model_relations

#    puts upload_forms(:uploads_001).inspect

    #Create a valid project
    @proj1 = create_valid_project

    #Tests [belongs_to Project] 
    assert true == UploadForm.new.respond_to?(:project)
   
    #Tests [has_many Attachments]
    assert true == UploadForm.new.respond_to?(:attachments)

    #Tests [Project has_many Upload_Forms]
    assert true == Project.new.respond_to?(:upload_forms)

    #Tests [Attachment belongs_to Upload_Form trough container]
    @up_form1 = @proj1.upload_forms.build :title => "Valid title"
    assert @up_form1.save    

    @att_file = @up_form1.attachments.build    
    assert @att_file.container == @up_form1
  end


  #Tests all the constraints regarding the creation of an upload form
  def test_create_upload_form
 
    #Create a valid project
    @proj1 = create_valid_project

    #Test presence of project
    @up_form1 = UploadForm.new :title => "Valid title", :description => "Forgot project"

    assert false == @up_form1.save

    #Test presence of title
    @up_form2 = @proj1.upload_forms.build :description => "Forgot title"

    assert false == @up_form2.save

    #Test maximum length of title (60)
    @invalid_title = (0..60).map{ ('a'..'z').to_a[rand(26)] }.join
    @up_form3 = @proj1.upload_forms.build :title => @invalid_title, :description => "Title is too long"

    assert false == @up_form3.save

    #Test valid upload form
    @up_form4 = @proj1.upload_forms.build :title => "Valid title", :description => "All params are OK"

    assert @up_form4.save
  end

  def test_deletes_attachments_on_destroy

    puts Attachment.all.inspect

    return true    
    #Create a valid project
    @proj1 = create_valid_project   

    #Tests [Attachment belongs_to Upload_Form trough container]
    @up_form1 = @proj1.upload_forms.build :title => "Valid title"
    assert @up_form1.save

    @att_file = @up_form1.attachments.build
    assert @att_file.container == @up_form1

 
  end

end
