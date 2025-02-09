Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    namespace :v1 do
      #user's routes

      post 'register', to: 'users#register' #, as: 'create_user' WORKING
      post 'login', to: 'users#login'
      get 'profile', to: 'users#profile'
      post 'forgetpassword', to: 'users#forgetpassword'
      post 'resetpassword/:id', to: 'users#resetpassword'

      #notes routes.
      
      post 'notes/create' => 'notes#create'    #create new note ok
      get 'notes/getnote' => 'notes#getnote'           #getnotes ok
      put 'notes/archive/:id'=>'notes#archive'      #archive toggle  ok
      put 'notes/trash/:id'=> 'notes#trash'        #trash toggle ok
      put 'notes/update_color/:id/:color' => 'notes#update_color' #update color
      #put 'notes/update/:id' => 'notes#update'      #update notes
      
    end  
  end
end 
