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

  # Devise 및 일반 필드 검증 메시지 (일본어)
  validates :nickname,
            presence: { message: 'ニックネームを入力してください' },
            uniqueness: { case_sensitive: false, message: 'このニックネームはすでに使用されています' }
  validates :nickname,
            length: { in: 2..20, message: 'ニックネームは2文字以上20文字以内で入力してください' },
            allow_blank: true
  validates :terms_of_service, acceptance: { message: '利用規約に同意してください' }
  validates :privacy_policy, acceptance: { message: 'プライバシーポリシーに同意してください' }

  def validate_email_format
    unless email =~ /\A[^@\s]+@[a-zA-Z]+(\.[a-zA-Z]{2,})+\z/
      errors.add(:base, 'メールアドレスの形式が正しくありません')
    end
  end

  def password_complexity
    letters = password.scan(/[A-Za-z]/).size
    digits  = password.scan(/\d/).size
    special = password.scan(/[^A-Za-z0-9]/).size

    errors.add(:base, 'アルファベットを最低2文字含めてください') if letters < 2
    errors.add(:base, '数字を最低2文字含めてください') if digits < 2
    errors.add(:base, '記号を最低2文字含めてください') if special < 2
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

  # 팔로우(활동적 관계): 내가 팔로우하는 관계
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed

  # 팔로워(수동적 관계): 나를 팔로우하는 관계
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :conversation_memberships, dependent: :destroy
  has_many :conversations, through: :conversation_memberships

  def get_profile_image
    unless profile_image.attached?
      file_path = if guest?
                    Rails.root.join('app/assets/images/guest_no_image.jpg')
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
      guest.nickname = "ゲストユーザー"
      guest.skip_confirmation!
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      guest.profile_image.attach(io: File.open(file_path), filename: 'no_image.jpg', content_type: 'image/jpeg') unless guest.profile_image.attached?
      guest.save!(validate: false)
    elsif !guest.confirmed?
      guest.skip_confirmation!
      guest.save!(validate: false)
    end
    guest
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "ゲストアカウントの作成に失敗しました: #{e.message}"
    nil
  end

  def guest?
    email == "guest@example.com"
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    provider = access_token.provider
    uid = access_token.uid
    user = where(provider: provider, uid: uid).first

    if user
      user
    else
      user = find_by(email: data['email'])
      if user
        user.update(provider: provider, uid: uid)
        user
      else
        new(
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
    admin
  end

  def active_for_authentication?
    super && active?
  end

  def inactive_message
    !active? ? :account_disabled : super
  end

  private

  def combine_email_parts
    self.email = "#{email_local}@#{email_domain}"
  end
end
