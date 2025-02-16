Rails.application.routes.draw do
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

  root to: "homes#top"
  get '/about' => 'homes#about'

  resources :card_collections


  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
