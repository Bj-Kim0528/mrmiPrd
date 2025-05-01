# Rails.application.config.session_store :cookie_store,
#   key: '_mrmi_session',        # ← 여러분 앱에 맞게 고쳐주세요
#   expire_after: nil,           # 개발 중엔 nil, 운영에선 필요 시 분기 처리
#   secure: Rails.env.production?,
#   same_site: :lax



  Rails.application.config.session_store :cookie_store,
  key: '_myapp_session',
  expire_after: 25.minute,       # ← 1분으로 설정
  secure: Rails.env.production?,
  same_site: :lax