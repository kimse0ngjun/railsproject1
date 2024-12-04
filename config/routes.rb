Rails.application.routes.draw do
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
end
