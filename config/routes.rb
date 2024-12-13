Rails.application.routes.draw do
  get 'pages/home'

  devise_for :users
  root 'pages#home'

  resources :videos do
    member do
      patch :like, to: "video_reactions#like"
      patch :dislike, to: "video_reactions#dislike"
    end
    collection do
      get :search, to: "videos#search" # 검색 라우트 추가
    end

    # 댓글 생성 및 삭제 라우트 추가
    resources :comments do
      member do
        patch :like, to: "comments#like"  
        patch :dislike, to: "comments#dislike"  
      end
    end
  end

  # 회원가입
  resources :mains
  resources :categories, only: [:create]
end
