Rails.application.routes.draw do

  get '/' => 'client#index', as: :clients

  get 'client/:unique_id/view' => 'client#view', as: :client
  match 'client/:unique_id/edit' => 'client#edit', as: :client_edit, via: [:get, :post, :patch]
  match 'client/:id/mark_as_done' => 'client#mark_as_done', as: :client_mark_as_done, via: [:get, :post]
  match 'client/new' => 'client#new', as: :client_new, via: [:get, :post]

  get 'status/:unique_id' => 'status#view', as: :status

  match 'status-admin/:unique_id' => 'status_admin#index', as: :status_admin, via: [:get, :post]

  devise_for :users
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
