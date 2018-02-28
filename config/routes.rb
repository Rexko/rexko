Lexicon::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  
  scope "/(:locale)" do
    resources :lexemes
    get 'html(/:headword)' => 'lexemes#show_by_headword', :as => :exact_lexeme
    get 'lexemes/matching/:matchtype/*headword', 
      to: 'lexemes#matching', 
      defaults: { matchtype: 'contains' }, 
      constraints: { headword: /.+/, matchtype: /contains|exact_match/ }
    get 'lexemes/matching(/:matchtype)/*headword', 
      to: 'lexemes#matching', 
      as: :matching, 
      defaults: { matchtype: 'contains' }, 
      constraints: { headword: /.+/ }
    
    resources :loci
    get 'loci/show_by_author(/:author)' => 'loci#show_by_author'
    
    resources :languages
    
    resources :dictionaries
    
    # TODO: Audit whether these are used/necessary
    scaffoldy = [:attestations, :authors, :authorships, :sources, 
                 :dictionary_scopes, :etymologies, :etymotheses,
                 :glosses, :headwords, :interpretations, :notes,
                 :orthographs, :parses, :phonetic_forms, :senses, 
                 :subentries, :titles]
    scaffoldy.each do |resource|
      resources resource
    end
    
    root to: 'editor#index'
  end
end
