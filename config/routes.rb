Rails.application.routes.draw do
  

  get 'rakuten_searches/index'
  devise_for :admin, skip: [:registrations, :password], controllers: {
    sessions: 'admin/sessions'
  }

  namespace :admin do
    get 'dashboards', to: 'dashboards#index', as: :users_dashboard
    resources :themes, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :users, only: [:destroy, :update] do
      resources :card_collection_comments, only: [:index] do
        member do
          patch :comment_destroy  # 댓글 삭제 (deleted: true로 업데이트)
          patch :comment_restoration
          patch :reply_destroy 
          patch :reply_restoration
        end
      end
    end
  end

  resources :conversations, only: [:index, :show, :create, :destroy] do
    resources :messages, only: [:create]
  end
  mount ActionCable.server => '/cable'

  
  devise_for :users, controllers: {
  registrations: 'users/registrations',
  confirmations: 'users/confirmations',
  passwords: 'users/passwords',
  sessions: 'users/sessions',
  omniauth_callbacks: 'users/omniauth_callbacks'
}

  devise_scope :user do
    # 기존의 새 확인 이메일 요청 폼은 그대로 두고,
    # 새롭게 커스터마이즈한 인증 페이지 경로를 추가합니다.
    get 'users/confirmations/certification', to: 'users/confirmations#certification', as: :certification
    post 'users/confirmations/certificate', to: 'users/confirmations#certificate', as: :certificate

    get 'users/confirmations/resend', to: 'users/confirmations#resend', as: :resend_confirmation
    post 'users/confirmations/resend', to: 'users/confirmations#resend'
  

    # 비밀번호 재설정 인증번호(토큰) 입력 페이지
    get "users/password/certification", to: "users/passwords#certification", as: :password_certification
    # 사용자가 입력한 토큰을 검증하는 액션 (POST 요청)
    post "users/password/verify_token", to: "users/passwords#verify_token", as: :verify_password_token

    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
    delete 'users/sign_out', to: 'users/sessions#destroy'

    get 'users/sns_sign_up', to: 'users/registrations#sns_sign_up', as: :sns_sign_up
  end


  resources :card_collections do
    resources :card_collection_comments, only: [:create, :destroy] do
      resources :card_collection_replies, only: [:create, :destroy]
    end
  end
  
  resources :card_images, only: [] do
    member do
      delete :clear
    end
  end
  
  resources :users, only: [:show, :edit, :update, :destroy] do
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


  resources :rakuten_searches, only: [:index]

  root to: "homes#top"
  get '/about' => 'homes#about'

  get '/topics/hashtag-channel', to: 'topics#hashtag_channel', as: 'hashtag_channel'
  get '/topics/recommend', to: 'topics#recommend', as: 'recommend'
  get '/topics/:theme_name', to: 'topics#show', as: 'topic'

  get 'search/index', to: 'search#index', as: 'searchs'
  get '/search/photos', to: 'search#photos', as: 'search_photos'
  get '/search/users', to: 'search#users', as: 'search_users'
  get '/search/hashtags', to: 'search#hashtags', as: 'search_hashtags'



  get '/hashtags/:name', to: 'hashtags#show', as: :hashtag

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
