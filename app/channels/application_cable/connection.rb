# app/channels/application_cable/connection.rb
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_warden_user || find_session_user
    end

    private

    # 1. 우선 Warden(=Devise)에서 꺼내 본다
    def find_warden_user
      env['warden'].user
    rescue
      nil
    end

    # 2. 폴백: 세션 쿠키를 직접 꺼내서 파싱
    def find_session_user
      session_key  = Rails.application.config.session_options[:key]
      session_data = cookies.encrypted[session_key] || {}
      warden_info  = session_data["warden.user.user.key"]&.first
      if warden_info
        User.find_by(id: warden_info.first)
      end
    end
  end
end
