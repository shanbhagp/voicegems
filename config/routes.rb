App4::Application.routes.draw do

  get "password_resets/new"

  resources :password_resets

  resources :subscriptions 

  resources :admininvites

  resources :userinvites

  resources :practiceobjects do
    member do
      get :porecording #nested routes was unnecessary here.  I'm passing in the relevant po id through the host option in the javascript, directly to the posaveupload url
                        # that's incorrect - this is allowing me to set @po in within the porecording action, which then is used to pass into the javascript and posaveupload action.
    end
  end 

  resources :adminkeys

  resources :customerkeys

 # resources :events, :path => '/'
#resources :posts, :path => "/admin/posts"
 resources :events

  resources :users do
    member do
      get :account
      put :post_account
      get :test
      post :hide
      get :setpassword
    end
  end



 root to: 'users#home'
  
  resources :sessions, only: [:create, :destroy]

  match '/signin',  to: 'users#home'
  match '/signout', to: 'sessions#destroy', via: :delete

  match '/users/new/:token', to: 'users#new'
  #match 'invitedsignup/:token', to: 'users#invitedsignup', via: :get 
  #need to figure out how to do this custome matching thing - keep getting error that ther is no route matching [get] /invitedusers

  #resources :customerkeys, only: [:create, :destroy, :index]

  #path to remind a registered user to record their name
  match '/reminder', to: 'userinvites#reminder'#, via: :post 
  match '/rerecord', to: 'userinvites#rerecord'#, via: :post 

  match '/adminsignup/:token', to: 'admininvites#adminsignup', as: '/adminsignup'
  match '/adminsignup', to: 'users#home'  #this is to get rid of the 'no route matches GET adminsignup' for hitting that page w/o an invite
  #need to figure out why this is happening.  What does 'as' do? And why don't we have the same problem with users/new? probably because that's a restful resource

  match '/adminusercreate', to: 'admininvites#adminusercreate', via: :post 

  match '/homepageusercreate', to: 'users#homepageusercreate', via: :post
  #added a leading slash here, after it was already working

  match '/console', to: 'users#console'
  #solely for my own use; restrict this when deployed

  match '/saverecording', to: 'users#saverecording', via: :post 

  match '/upload', to: 'users#upload', via: :post

  match '/saveupload', to: 'users#saveupload'

  match '/playtest', to: 'users#playtest'

  match '/addpo', to: 'sessions#addpo'

  match '/addadmin', to: 'sessions#addadmin'

 match '/posaveupload', to: 'practiceobjects#posaveupload' 

 match '/eventcodesignup', to: 'users#eventcodesignup'
 match '/eventcodesignupcreate', to: 'users#eventcodesignupcreate', via: :post 
 match 'eventcodesignup_step2', to: 'users#eventcodesignup_step2'

 # signing up a new user with an event code
 #match '/signup', to: 'users#signup'

 match '/addeventcodeuser', to: 'sessions#addeventcodeuser'

 match '/admincodesignup', to: 'users#admincodesignup'
 match '/admincodesignupcreate', to: 'users#admincodesignupcreate', via: :post 

 match '/addcodeadmin', to: 'sessions#addcodeadmin'

 match '/stripetest', to: 'users#stripetest'

 match '/stripereceiver', to: 'users#stripereceiver' #, via: :post 

 match '/cancel', to: 'subscriptions#cancel'

 match '/unsubscribe', to: 'subscriptions#unsubscribe'

 match '/newcustomer', to: 'users#newcustomer'

 match '/newcustomercreate', to: 'users#newcustomercreate'

 match '/stripenewcustomer', to: 'users#stripenewcustomer'

 match '/unhide', to: 'practiceobjects#unhide'

 match '/removeadmin', to: 'adminkeys#removeadmin'

 match '/new_step2', to: 'users#new_step2'
 #note that we don't use the :token thing here, even though token passed in- this is different both from the users-new and adminsignup methods!
 
 match '/skip', to: 'users#skip'

 match '/changepassword', to: 'users#changepassword'

 match '/value', to: 'static#value'
 match '/works', to: 'static#works'

 match '/test', to: 'users#test'

 #match '/events/assets/' => redirect('/assets')
# match '/events/assets/etc' => redirect('/assets/%{etc}')
#match "/stories/:name" => redirect("/posts/%{name}")
# match '/events/assets/*etc' => redirect('/assets/%{etc}')
#match '/events/assets/aplayer/*a' => redirect('/assets/aplayer/%{a}'), :requirements => { :a => /.*/ }
#match '/events/assets/aplayer/audiojs.swf?playerInstance=audiojs/*a' => redirect('/assets/aplayer/audiojs.swf?playerInstance=audiojs%{a}'), :constraints => { :a => /.*/ }
match '/events/assets/aplayer/:a' => redirect('/assets/aplayer/%{a}'), :requirements => { :a => /.*/ }
#savannah-5516.herokuapp.com/assets/aplayer/audiojs.swf?playerInstance=audiojs.instances[%27audiojs0%27]&datetime=1352004313978.8704
 #match '/hide/:id', to: 'practiceobjects#destroy', via: :destroy

  #match ':controller(/:action(/:id))(.:format)' 
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

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
