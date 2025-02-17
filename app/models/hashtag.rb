class Hashtag < ApplicationRecord
  has_many :card_collection_hashtags, dependent: :destroy
  has_many :card_collections, through: :card_collection_hashtags

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end