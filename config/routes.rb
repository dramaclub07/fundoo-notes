Rails.application.routes.draw do  
  namespace :api do  
    namespace :v1 do  
      post '/users', to: 'users#create', as: 'create_user'  
    end  
  end  
end