Rails.application.routes.draw do
  resources :articles
  resources :comments
  root 'welcome#index'
end