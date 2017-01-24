Lexicon::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

	scope "/(:locale)" do
    get "parsable/index" => 'parsable#index'
    match 'lexemes/matching(/:matchtype)/:headword', :to => 'lexemes#matching', :as => :matching, :defaults => { :matchtype => 'contains' }
    match 'author(/:author(/:page))' => 'loci#matching'
    match 'loci/show_by_author(/:author)' => 'loci#show_by_author'
    match 'unattached/matching/:forms' => 'loci#unattached'
    match 'unattached/:id' => 'loci#unattached'
    match 'html(/:headword)' => 'lexemes#show_by_headword', :as => :exact_lexeme
    resources :sort_orders
    resources :notes
    resources :interpretations
    resources :parses
    resources :attestations
    resources :orthographs
    resources :etymotheses
    resources :dictionary_scopes
    resources :authorships do
      post 'matching', on: :collection
    end
    resources :authors do
      post 'matching', on: :collection
    end
    resources :titles do
      post 'matching', on: :collection
    end
    resources :sources
    resources :loci
    match 'loci(/index(/*loci))' => 'loci#index'  #replace this
    resources :glosses
    resources :senses
    resources :etymologies
    resources :phonetic_forms
    resources :headwords
    resources :subentries
    resources :lexemes
    resources :dictionaries
    resources :languages do
      post 'matching', on: :collection
    end

    # You can have the root of your site routed with "root"
    # just remember to delete public/index.html.
    # root :to => "welcome#index"
    root :to => 'editor#index'
  end

  match '/:locale' => 'editor#index'

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end