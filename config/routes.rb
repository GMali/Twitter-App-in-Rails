Twitterapp::Application.routes.draw do
  match "/login" => "user#login"
  match "/logout" => "sessions#destroy"
  match "/authenticate" => "sessions#create"
  match "/twitter_sign_in" => "sessions#new"
  root :to => 'user#index'
end
