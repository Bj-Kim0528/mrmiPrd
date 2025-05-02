require 'open-uri'

class Tag < ApplicationRecord
  belongs_to :card_image
  has_one_attached :image
  after_commit :download_and_attach_image, on: :create

  validates :name, presence: true
  validates :url,  presence: true, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])

  private

  def download_and_attach_image
    return unless image_url.present?
    file = URI.open(image_url)
    filename = File.basename(URI.parse(image_url).path)
    image.attach(io: file, filename: filename)
  rescue => e
    Rails.logger.error "Tag ##{id} 이미지 첨부 실패: #{e.message}"
  end
end
