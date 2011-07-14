class TestForm < ActiveRecord::Base
  unloadable
  belongs_to :project

end
