WeddingGuest::Application.routes.draw do
  devise_for :users, :controllers => { :sessions => 'users/sessions' }

  resources :weddings do
    member do
      get 'rotate_image'
      get 'terms_and_conditions'
    end
    collection { get 'delete_all' }

    resources :guests, :only => [:index, :create, :update]
    resources :list_managers, :only => [:index, :create, :update] do
      member { get 'owner' }
    end
    resources :gifts, :only => [:index]
    resources :addresses
    resources :details do
      member {
        put 'sort'
        get 'set'
        post 'set'
      }
    end
  end

  resources :waste, :only => :index


  resources :resources, :only => [:show] do
    member do
      get 'image_cache', :requirements => { :cache_id => /\d{8}-\d{4}-\d{5}-\d{4}/, :filename => /[a-zA-Z0-9_ ]+\.(jpg|jpeg){1}/i }
    end
  end

  match ':wedding_name(/:name)' => 'external#show', :as => :external

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

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'weddings#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
