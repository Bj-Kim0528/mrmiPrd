class Hashtag < ApplicationRecord
  has_many :card_collection_hashtags, dependent: :destroy
  has_many :card_collections, through: :card_collection_hashtags
  has_many :bookmarks, as: :bookmarkable, dependent: :destroy

  validates :name, presence: true, 
                  uniqueness: { case_sensitive: false },
                  format: { without: /\A\d+\z/, message: "cannot be only numbers" }

  def to_param
    name
  end
end