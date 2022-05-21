Rails.application.routes.draw do
  scope '/(:locale)' do
    resources :lexemes
    match 'html(/:headword)' => 'lexemes#show_by_headword', as: :exact_lexeme, via: %i[get post]
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
    get 'author(/:author(/:page))' => 'loci#matching'
    get 'unattached/:id' => 'loci#unattached'

    resources :languages

    resources :dictionaries

    get 'parsable/index' => 'parsable#index'

    # TODO: Audit whether these are used/necessary
    scaffoldy = %i[attestations authors authorships sources
                   dictionary_scopes etymologies etymotheses
                   glosses headwords interpretations notes
                   orthographs parses phonetic_forms senses
                   subentries titles]
    scaffoldy.each do |resource|
      resources resource
    end

    root to: 'editor#index'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
