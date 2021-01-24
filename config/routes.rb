Rails.application.routes.draw do
  resources :reviews
  resources :actionlogs

  resources :submissions, except: :new
  match '/submissions/new/:article_id', to: 'submissions#new', via: 'get'
  match '/submissions/new', to: 'submissions#new', via: 'post'
  get '/submissions/:id/download', to: 'submissions#download'

  resources :conflicts, :only => [:create, :destroy]
  resources :reviewers
  resources :editors, :only => [:create, :destroy]
  resources :authors

  resources :articles
  get 'all_articles', to: 'articles#all_index'
  get 'my_articles', to: 'articles#my_index'
  get 'approvals', to: 'articles#approval_index'
  get 'approvals_info', to: 'articles#approval_index_for_admin'
  get 'issue/:volume/:number', to: 'articles#issue'
  put 'issue/:volume/:number', to: 'articles#issue_done'
  get 'search/:pattern', to: 'articles#search'
  get '/articles/:id/reviewing_begins/:number', to: 'articles#reviewing_begins'
  get '/articles/:id/editor_request', to: 'articles#editor_request'
  get '/articles/:id/review_request/:number', to: 'articles#review_request'
  get '/articles/:id/report/:number', to: 'articles#report'
  get '/articles/:id/accept_letter', to: 'articles#accept_letter'
  get '/articles/:id/reject_letter', to: 'articles#reject_letter'
  get '/articles/:id/final_accept_letter', to: 'articles#final_accept_letter'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :users

  root :to => 'sessions#new'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
