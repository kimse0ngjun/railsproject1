Rails.application.routes.draw do
  get 'pages/home'

  devise_for :users
  root 'pages#home'

  resources :videos do
    member do
      patch 'increment_views'
	  patch :like
      patch :dislike
    end

    collection do
      get :search, to: "videos#search" # 검색 라우트 추가
    end

    # 댓글 생성 및 삭제 라우트 추가
    resources :comments, only: [:create, :destroy, :update] do
      member do
        patch :like   # 댓글 좋아요
        patch :dislike # 댓글 싫어요
      end
    end
  end

  # 회원가입
  resources :mains
  resources :categories, only: [:create]
end
