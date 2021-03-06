Microblog::Application.routes.draw do

  resources :feeds do 
    post "forward"=>:forward, :as=>"forward"
  end


  resources :groups
  resources :users

  controller :sessions do
    get 'signin'=>:new
    post 'signin'=>:create
    get 'home'=>:index
    delete "signout"=>:destroy
  end

  controller :fans do
    get 'fans'=>:index
  end

  controller :follows do
    get 'follows'=>:index
    post 'follows'=>:create
    delete "follows/:id"=>:destroy, :as=>"follow"
  end

  get 'groups/:group_id/follows' =>'groups#follows',:as=>"group_follows"
  post 'groups/:group_id/follows'=>'groups#add_follow_to_group',:as=>"add_group_follow"

  get 'attachments/:id'=>'attachments#show',:as=>'attachments'

  get 'users/:id/profile/feeds'=>'users#feeds',:as=>'self_feeds'

  get 'users/:id/feeds'=>'users#refresh_feeds',:as=>'refresh_feeds'

  get 'feeds/:id/comments'=>'feeds#comments',:as=>'comments'

  post 'feeds/:id/comment'=>'feeds#comment',:as=>'Comment'


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
  # root :to => 'welcome#index'
  root :to=>'sessions#index',:as=>'home'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
