class CardCollection < ApplicationRecord
  belongs_to :user

  # Active Storage를 사용하여 여러 장의 사진 첨부 (최대 10장)
  has_many_attached :photos

  # 해시태그와의 다대다 관계 (조인 테이블 CardCollectionHashtag를 통해)
  has_many :card_collection_hashtags, dependent: :destroy
  has_many :hashtags, through: :card_collection_hashtags

  # 사진 첨부 갯수 제한 검증
  validate :photo_limit

  # 게시글 본문(content)에서 해시태그 추출 후 연관 생성 (저장 후 실행)
  after_save :extract_hashtags

  private

  def photo_limit
    if photos.attached? && photos.count > 10
      errors.add(:photos, "can have at most 10 images")
    end
  end

  def extract_hashtags
    return if content.blank?
  
    # "#" 다음에 공백 없이 문자와 숫자만 허용 (밑줄 제외, 글자수 제한 없음)
    hashtag_names = content.scan(/#([\p{L}\p{N}]+)(?=[^\p{L}\p{N}]|$)/u).flatten
    hashtag_names.map!(&:downcase)
    hashtag_names.uniq!
  
    # 숫자만으로 구성된 해시태그는 제거 (예: "#12345" 무시)
    hashtag_names.reject! { |name| name.match?(/\A\d+\z/) }
  
    # 만약 해시태그와 쉼표 등 구두점 사이에 공백이 없이 연달아 나온 경우,
    # 예: "#111ㅇㅇ,#111122ㄴㄴ"처럼 콤마 바로 뒤에 공백이 없다면, 
    # 첫 번째 해시태그만 사용하도록 처리합니다.
    if content =~ /#[\p{L}\p{N}]+,(?!\s)/u
      hashtag_names = [hashtag_names.first].compact
    end
  
    # 기존 해시태그 연관 제거 (필요에 따라 업데이트 로직으로 대체 가능)
    card_collection_hashtags.destroy_all
  
    hashtag_names.each do |name|
      hashtag = Hashtag.find_or_create_by(name: name)
      card_collection_hashtags.create(hashtag: hashtag)
    end
  end
  
end
