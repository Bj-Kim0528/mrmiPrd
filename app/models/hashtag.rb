class Hashtag < ApplicationRecord
  has_many :card_collection_hashtags, dependent: :destroy
  has_many :card_collections, through: :card_collection_hashtags

  validates :name, presence: true, 
                  uniqueness: { case_sensitive: false },
                  format: { without: /\A\d+\z/, message: "cannot be only numbers" }
end