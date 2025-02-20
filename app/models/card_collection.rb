class CardCollection < ApplicationRecord
  belongs_to :user

  has_many_attached :photos
  has_many :card_collection_hashtags, dependent: :destroy
  has_many :hashtags, through: :card_collection_hashtags

  serialize :contents, Array
  validate :photo_limit
  after_save :extract_hashtags

  before_save :remove_blank_contents

  private

  def photo_limit
    if photos.attached? && photos.count > 10
      errors.add(:photos, "can have at most 10 images")
    end
  end

  def remove_blank_contents
    # 빈 문자열을 제거해서, 실제 입력된 값들만 저장
    self.contents = self.contents.reject(&:blank?) if contents.present?
  end

  def extract_hashtags
    return if contents.blank?
    
    # 배열로 저장된 contents를 하나의 문자열로 결합 (각 항목 사이에 공백 추가)
    text = contents.join(" ")
  
    # "#" 다음에 공백 없이 글자와 숫자만 허용하는 해시태그 추출 (밑줄 제외)
    hashtag_names = text.scan(/#([\p{L}\p{N}]+)(?=[^\p{L}\p{N}]|$)/u).flatten
    hashtag_names.map!(&:downcase)
    hashtag_names.uniq!
    
    # 숫자만으로 구성된 해시태그는 제거 (예: "#12345" 무시)
    hashtag_names.reject! { |name| name.match?(/\A\d+\z/) }
    
    # 만약 해시태그와 쉼표 등 구두점 사이에 공백 없이 연달아 나온 경우,
    # 예: "#111ㅇㅇ,#111122ㄴㄴ"처럼 콤마 바로 뒤에 공백이 없다면, 
    # 첫 번째 해시태그만 사용하도록 처리합니다.
    if text =~ /#[\p{L}\p{N}]+,(?!\s)/u
      hashtag_names = [hashtag_names.first].compact
    end
  
    card_collection_hashtags.destroy_all
    hashtag_names.each do |name|
      hashtag = Hashtag.find_or_create_by(name: name)
      card_collection_hashtags.create(hashtag: hashtag)
    end
  end
end
