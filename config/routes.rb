OauthProviderDemo::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => 'registrations',
                                       :sessions => 'sessions',
                                       omniauth_callbacks: 'omniauth_callbacks'}


  devise_scope :user do
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  # omniauth client stuff
  match '/auth/:provider/callback', :to => 'authentications#create'
  match '/auth/failure', :to => 'authentications#failure'

  # Provider stuff
  match '/auth/formation/authorize' => 'auth#authorize'
  match '/auth/formation/access_token' => 'auth#access_token'
  match '/auth/formation/user' => 'auth#user'
  match '/oauth/token' => 'auth#access_token'

  root :to => 'auth#welcome'
end
