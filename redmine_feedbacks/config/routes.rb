#custom routes for this plugin
ActionController::Routing::Routes.draw do |map|
  map.resources :projects, :only => [] do |project|
   project.resources :feedbacks, :shallow => true, :new => { :preview => :post}, :member => {:lock => :post, :edit => :post} do |feedback|
   # feedback.resources   :edit => :post  do 
   # end
    end
  end
end
