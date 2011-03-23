ActionController::Routing::Routes.draw do |map|
  map.connect "lexemes/matching/:headword",
    :controller => "lexemes",
    :action => "matching" 
  
  map.connect "author/:author",
    :controller => "loci",
    :action => "show_by_author"
  
  map.connect "unattached/:id",
    :controller => "loci",
    :action => "unattached"
  
  map.connect "html/:headword",
    :controller => "lexemes",
    :action => "show_by_headword" 
    
  map.resources :interpretations

  map.resources :parses

  map.resources :attestations

  map.resources :orthographs

  map.resources :etymotheses

  map.resources :dictionary_scopes

  map.resources :authorships

  map.resources :authors

  map.resources :titles

  map.resources :sources

  map.resources :loci

  map.resources :glosses

  map.resources :senses

  map.resources :etymologies

  map.resources :phonetic_forms

  map.resources :headwords

  map.resources :subentries

  map.resources :lexemes

  map.resources :dictionaries
  
  map.resources :languages

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"
  map.root :controller => "editor"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
