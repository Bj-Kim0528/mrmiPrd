Rails.application.routes.draw do
  get 'search/index'
  devise_for :users, controllers: {
  registrations: 'users/registrations',
  confirmations: 'users/confirmations'
}
  devise_scope :user do
    # 기존의 새 확인 이메일 요청 폼은 그대로 두고,
    # 새롭게 커스터마이즈한 인증 페이지 경로를 추가합니다.
    get 'users/confirmations/certification', to: 'users/confirmations#certification', as: :certification
    post 'users/confirmations/certificate', to: 'users/confirmations#certificate', as: :certificate
  end
  resources :card_collections
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
    end
  end



  root to: "homes#top"
  get '/about' => 'homes#about'

  get '/topics/hashtag-channel', to: 'topics#hashtag_channel', as: 'hashtag_channel'
  get '/topics/:theme', to: 'topics#show', as: 'topic'

  get 'search/index', to: 'search#index'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
