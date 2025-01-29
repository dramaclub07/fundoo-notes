Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'register', to: 'users#register'
      post 'login', to: 'users#login'
      get 'profile', to: 'users#profile'
    end
  end
end
# Rails.application.routes.draw do
  #get "users/index"
#   # get "sessions/new"
#   # get "sessions/create"
#   # get "sessions/destroy"
  
#   # root 'notes#home'   
#   # get "notes/home"
#   get 'login', to: 'sessions#new'  
#   post 'login', to: 'sessions#create'  
#   delete 'logout', to: 'sessions#destroy'  
#   namespace :api do  
#     namespace :v1 do 
#       post '/users', to: 'users#create', as: 'create_user'  
#     end  
#   end  
# end

# Rails.application.routes.draw do  
#   # Session routes    
#   # API namespace for user login  
#   namespace :api do  
#     namespace :v1 do  
#       post '/users', to: 'users#create', as: 'create_user'
#       post 'users/login', to: 'users#login', as: 'login' # Make sure to add `as: 'login'` 
#       get 'login', to: 'sessions#new' 
#       get 'users', to: 'users#index' 
       
#     end  
#   end  
# end