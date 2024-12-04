Rails.application.routes.draw do
<<<<<<< HEAD
  get 'pages/home'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root 'pages#home'

  resources :videos do
    member do
      patch :like, to: "video_reactions#like"
      patch :dislike, to: "video_reactions#dislike"
    end
    collection do
      get :search, to: "videos#search" # 검색 라우트 추가
    end

    # 댓글 생성 라우트 추가
    resources :comments, only: [:create]
  end
=======
  # 로그인
  get 'login', to: 'sessions#new', as: 'new_session'  # 로그인 폼
  post '/login', to: 'sessions#create', as: 'session'   # 로그인 처리
  
  # 회원가입
  resources :mains
  resources :categories, only: [:create]

  # 루트 경로
  root 'mains#index'
>>>>>>> develop-sw
end
