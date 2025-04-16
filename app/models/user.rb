class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: [:google_oauth2]

  # email_local (이메일 아이디 부분)
  attr_accessor :email_local

  # email_domain (이메일 도메인 부분)
  attr_accessor :email_domain
  # 회원가입 시 email_local, email_domain을 합쳐서 email 필드에 저장
  before_validation :combine_email_parts, if: -> { email_local.present? && email_domain.present? }

  # 이메일 형식 검증 (회원가입 시)
  validate :validate_email_format
  validate :password_complexity, if: -> { password.present? }

  validates :encrypted_password, presence: true
  validates :nickname, presence: true, uniqueness: { case_sensitive: false }
  validates :nickname, length: { in: 2..20 }, allow_blank: true
  validates :terms_of_service, acceptance: { message: "must be accepted" }
  validates :privacy_policy, acceptance: { message: "must be accepted" }

  def validate_email_format
    unless email =~ /\A[^@\s]+@[a-zA-Z]+(\.[a-zA-Z]{2,})+\z/
      errors.add(:base, "올바른 이메일 형식이 아닙니다")
    end
  end

  has_many :card_collections, dependent: :destroy
  has_many :card_collection_comments, dependent: :destroy
  has_many :card_collection_replies, dependent: :destroy
  has_one_attached :profile_image

  has_many :likes, dependent: :destroy
  has_many :liked_card_collections, through: :likes, source: :likeable, source_type: "CardCollection"

  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_card_collections, through: :bookmarks, source: :bookmarkable, source_type: "CardCollection"
  has_many :bookmarked_hashtags, through: :bookmarks, source: :bookmarkable, source_type: "Hashtag"

  # 팔로우(활동적 관계): 내가 팔로우하는 관계 (follower_id가 나인 관계)
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed

  # 팔로워(수동적 관계): 다른 사용자가 나를 팔로우하는 관계 (followed_id가 나인 관계)
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower


  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = if guest?
                    Rails.root.join('app/assets/images/guest_no_image.jpg')  # 게스트 전용 기본 이미지
                  else
                    Rails.root.join('app/assets/images/no_image.jpg')
                  end
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image
  end


  def self.guest
    guest = find_or_initialize_by(email: 'guest@example.com')
    if guest.new_record?
      guest.password = SecureRandom.urlsafe_base64
      guest.nickname = "게스트 사용자"
      guest.skip_confirmation!
      # 기본 프로필 이미지로 no_image.jpg 첨부 (파일 경로와 이름을 실제 파일에 맞게 수정)
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      guest.profile_image.attach(io: File.open(file_path), filename: 'no_image.jpg', content_type: 'image/jpeg') unless guest.profile_image.attached?
      guest.save!(validate: false)
    elsif !guest.confirmed?
      guest.skip_confirmation!
      guest.save!(validate: false)
    end
    guest
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "게스트 계정 생성 실패: #{e.message}"
    nil
  end
  

  def guest?
    email == "guest@example.com"
  end


  def self.from_omniauth(access_token)
    data = access_token.info
    provider = access_token.provider
    uid = access_token.uid

    # 먼저 provider와 uid로 기존 사용자를 찾습니다.
    user = User.where(provider: provider, uid: uid).first

    if user
      # 이미 가입된 사용자가 있다면 그대로 반환
      user
    else
      # 만약 없으면, 이메일로 사용자를 찾아봅니다.
      user = User.find_by(email: data['email'])
      if user
        # 기존 계정이 있으나 provider, uid가 기록되지 않은 경우, 업데이트
        user.update(provider: provider, uid: uid)
        user
      else
        # 신규 사용자 객체를 초기화만 하고, 저장은 회원가입 폼에서 진행
        User.new(
          email: data['email'],
          password: Devise.friendly_token[0,20],
          provider: provider,
          uid: uid,
          nickname: data['name']
        )
      end
    end
  end

  def admin?
    self.admin
  end

  def active_for_authentication?
    super && active?
  end

  def inactive_message
    if !active?
      :account_disabled  # config/locales/devise.en.yml (또는 해당 언어의 파일)에 메시지를 추가합니다.
    else
      super
    end
  end

  private

  # email_local + email_domain을 email로 저장
  def combine_email_parts
    self.email = "#{email_local}@#{email_domain}"
  end


  def password_complexity
    letters = password.scan(/[A-Za-z]/).size
    digits  = password.scan(/\d/).size
    special = password.scan(/[^A-Za-z0-9]/).size

    errors.add(:base, "최소 2개이상의 알파벳") if letters < 2
    errors.add(:base, "최소 2개이상의 숫자") if digits < 2
    errors.add(:base, "최소 2개이상의 기호") if special < 2
  end
end
