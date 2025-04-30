
Rails.application.config.session_store :cookie_store,
  key: '_myapp_session',
  expire_after: 1.minute,       # ← 1분으로 설정
  secure: Rails.env.production?,
  same_site: :lax