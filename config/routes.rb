Rails.application.routes.draw do

  devise_for :users,
             path: '',
             path_names: { sign_in: 'login', sign_out: 'logout'},
             controllers: {
                 sessions: 'users/sessions'
             }

  # The home page is a splash page with a login/register link and various static page links
  root 'static_pages#home'
  
  # Static pages accessible when not logged in
  get 'help' => 'static_pages#help'
  get 'about' => 'static_pages#about'
  
  # Project resources
  # http://www.codecademy.com/articles/standard-controller-actions
  
  resources :users
  resources :courses
  resources :projects
  resources :mini_projects
  resources :standard_reservations
  resources :film_digitizations
  resources :vidcams
  resources :works
  resources :films do
    collection do
      get :autocomplete
    end
  end
  resources :tags

  # Multi-resource searching
  get 'search' => 'search#index'
  
  # App live configuration
  get 'configuration' => 'application_configurations#edit'
  patch 'configuration' => 'application_configurations#update'
  
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
end
