class CardCollection < ApplicationRecord
  belongs_to :user
  belongs_to :theme, optional: true
  
  # 기존 has_many_attached :photos 와 serialize :contents 제거
  has_many :card_images, -> { order(Arel.sql("CASE WHEN position IS NULL THEN 1 ELSE 0 END, position ASC")) }, dependent: :destroy, inverse_of: :card_collection
  accepts_nested_attributes_for :card_images, allow_destroy: true
  before_save :update_card_images_positions
  
  has_many :card_collection_hashtags, dependent: :destroy
  has_many :hashtags, through: :card_collection_hashtags

  has_many :card_collection_comments, dependent: :destroy

  has_many :likes, as: :likeable, dependent: :destroy

  has_many :bookmarks, as: :bookmarkable, dependent: :destroy
  has_many :bookmarking_users, through: :bookmarks, source: :user
  
  # 최대 10개의 이미지 제한 (CardImage 기준)
  validate :card_images_limit



  validate :card_images_with_content_must_have_images
  
  # 카드 컬렉션이 저장된 후, 카드 이미지의 내용에서 해시태그 추출
  after_save :extract_hashtags_from_images
  
  private
  
  def card_images_limit
    if card_images.size > 10
      errors.add(:card_images, "can have at most 10 images")
    end
  end


  def card_images_with_content_must_have_images
    card_images.each_with_index do |ci, index|
      if ci.content.present? && !ci.image.attached?
        errors.add(:base, "카드 이미지 #{index + 1}의 이미지를 첨부해야 합니다.")
      end
    end
  end
  
  def extract_hashtags_from_images
    # 각 CardImage의 content 값을 모아서 하나의 문자열로 결합
    contents = card_images.map(&:content).reject(&:blank?)
    return if contents.blank?
  
    text = contents.join(" ")
    
    # "#" 다음에 공백 없이 글자와 숫자만 허용하는 해시태그 추출 (밑줄 제외)
    hashtag_names = text.scan(/#([\p{L}\p{N}]+)(?=[^\p{L}\p{N}]|$)/u).flatten
    hashtag_names.map!(&:downcase)
    hashtag_names.uniq!
    hashtag_names.reject! { |name| name.match?(/\A\d+\z/) }
    
    # 예: "#abc,#def"처럼 콤마 바로 뒤에 공백이 없으면 첫 번째 해시태그만 사용하도록 처리
    if text =~ /#[\p{L}\p{N}]+,(?!\s)/u
      hashtag_names = [hashtag_names.first].compact
    end
  
    # 기존 해시태그 연결 제거 후 재생성
    card_collection_hashtags.destroy_all
    hashtag_names.each do |name|
      hashtag = Hashtag.find_or_create_by(name: name)
      card_collection_hashtags.create(hashtag: hashtag)
    end
  end

  def update_card_images_positions
    count = 0
    # 10개의 CardImage가 이미 존재한다고 가정합니다.
    self.card_images.each do |ci|
      if ci.image.attached? || ci.content.present?
        count += 1
        ci.position = count
      else
        ci.position = nil
      end
    end
  end
end
