class Tag < ApplicationRecord
  belongs_to :card_image

  validates :name, presence: true
  validates :url,  presence: true, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])
end
