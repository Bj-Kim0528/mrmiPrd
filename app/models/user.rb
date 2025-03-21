class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

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
      errors.add(:base, "메일바리데이션(나중에수정)1")
    end
  end

  has_many :card_collections, dependent: :destroy
  has_many :card_collection_comments, dependent: :destroy
  has_one_attached :profile_image

  has_many :likes, dependent: :destroy
  has_many :liked_card_collections, through: :likes, source: :likeable, source_type: "CardCollection"

  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_card_collections, through: :bookmarks, source: :card_collection

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
        file_path = Rails.root.join('app/assets/images/no_image.jpg')
        profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
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
