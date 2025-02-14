class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # email_local (이메일 아이디 부분)
  attr_accessor :email_local

  # email_domain (이메일 도메인 부분)
  attr_accessor :email_domain
  # 회원가입 시 email_local, email_domain을 합쳐서 email 필드에 저장
  before_validation :combine_email_parts, if: -> { email_local.present? && email_domain.present? }

  # 이메일 형식 검증 (회원가입 시)
  validate :validate_email_format
  validates :encrypted_password, presence: true
  validates :nickname, 
            presence: true, 
            uniqueness: { case_sensitive: false }, 
            length: { in: 2..20 }
  validates :terms_of_service, acceptance: true
  validates :privacy_policy, acceptance: true

  def validate_email_format
    unless email =~ /\A[^@\s]+@[a-zA-Z]+(\.[a-zA-Z]{2,})+\z/
      errors.add(:base, "메일바리데이션(나중에수정)1")
    end
  end



  private

  # email_local + email_domain을 email로 저장
  def combine_email_parts
    self.email = "#{email_local}@#{email_domain}"
  end
end
