#custom routes for this plugin
ActionController::Routing::Routes.draw do |map|
  map.resources :projects, :only => [] do |project|
   project.resources :uploads, :shallow => true, :new => { :preview => :post}, :member => {:lock => :post, :update => [ :post, :get ], :addFiles => [:post] , :downloadAll => [:get] } do |upload| 
    end   
  end
end

