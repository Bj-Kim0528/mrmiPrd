class CardImage < ApplicationRecord
  belongs_to :card_collection, inverse_of: :card_images
  has_one_attached :image

  has_many   :tags, dependent: :destroy
  accepts_nested_attributes_for :tags, allow_destroy: true

  before_save :normalize_blank_values

  private

  def normalize_blank_values
    # content가 빈 문자열이면 nil로 변경
    self.content = nil if content.blank?
  end
end
