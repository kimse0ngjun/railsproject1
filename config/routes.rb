Rails.application.routes.draw do
  # 로그인
  get 'login', to: 'sessions#new', as: 'new_session'  # 로그인 폼
  post '/login', to: 'sessions#create', as: 'session'   # 로그인 처리
  
  # 회원가입
  resources :mains
  resources :categories, only: [:create]

  # 루트 경로
  root 'mains#index'
end
