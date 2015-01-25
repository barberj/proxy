require 'sidekiq/web'

Rails.application.routes.draw do

  root 'users#new'
  resources :dashboard, :only => [:index]

  get '/signin' => 'sessions#new'
  post '/signin' => 'sessions#create'
  get '/signout' => 'sessions#destroy'

  get '/docs', to: redirect('http://www.simpleapi.io/docs')
  get '/privacy-policy', to: redirect('http://www.simpleapi.io/privacy-policy')

  get '/signup' => 'users#new'

  namespace :v1 do
    scope :app do
      resources :users, :only => [:create]
      resources :jobs, :only => [:show]
      resources :apis, :only => [:index, :create, :destroy] do
        post '/image' => :add_image
        get '/image' => :get_image
      end
      resources :marketplace, :only => [:index, :create]
      resources :data_encodings, :only => [:index, :update, :destroy]
    end

    scope :api do
      get "/:encoded_resource"    => 'get_data#index'
      post "/:encoded_resource"   => 'post_data#create'
      put "/:encoded_resource"    => 'put_data#update'
      patch "/:encoded_resource"  => 'put_data#update'
      delete "/:encoded_resource" => 'delete_data#destroy'
    end

    get "/:encoded_resource"    => 'get_data#index'
    post "/:encoded_resource"   => 'post_data#create'
    put "/:encoded_resource"    => 'put_data#update'
    patch "/:encoded_resource"  => 'put_data#update'
    delete "/:encoded_resource" => 'delete_data#destroy'
  end

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
  mount Sidekiq::Web, at: '/sidekiq'
end
