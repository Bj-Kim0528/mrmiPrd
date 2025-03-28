Rails.application.routes.draw do
  
  get 'hashtags/show'
  devise_for :users, controllers: {
  registrations: 'users/registrations',
  confirmations: 'users/confirmations',
  passwords: "users/passwords"
}
  devise_scope :user do
    # 기존의 새 확인 이메일 요청 폼은 그대로 두고,
    # 새롭게 커스터마이즈한 인증 페이지 경로를 추가합니다.
    get 'users/confirmations/certification', to: 'users/confirmations#certification', as: :certification
    post 'users/confirmations/certificate', to: 'users/confirmations#certificate', as: :certificate

    # 비밀번호 재설정 인증번호(토큰) 입력 페이지
  get "users/password/certification", to: "users/passwords#certification", as: :password_certification
  # 사용자가 입력한 토큰을 검증하는 액션 (POST 요청)
  post "users/password/verify_token", to: "users/passwords#verify_token", as: :verify_password_token
  end

  resources :card_collections do
    resources :card_collection_comments, only: [:create, :destroy] do
      resources :card_collection_replies, only: [:create, :destroy]
    end
  end
  
  resources :card_images, only: [] do
    member do
      patch :clear
      patch :move_up
      patch :move_down
    end
  end
  
  resources :users, only: [:show, :edit, :update] do
    member do
      get :card_collections
      get :collections
      get :likes
      get :follower
      get :followee
      get :edit_password
      patch :update_password
    end
  end

  resources :likes, only: [:create, :destroy]

  resources :bookmarks, only: [:create, :destroy]

  resources :relationships, only: [:create, :destroy]

  root to: "homes#top"
  get '/about' => 'homes#about'

  get '/topics/hashtag-channel', to: 'topics#hashtag_channel', as: 'hashtag_channel'
  get '/topics/recommend', to: 'topics#recommend', as: 'recommend'
  get '/topics/:theme', to: 'topics#show', as: 'topic'

  get 'search/index', to: 'search#index'

  get '/hashtags/:name', to: 'hashtags#show', as: :hashtag

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
