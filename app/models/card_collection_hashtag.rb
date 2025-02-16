class CardCollectionHashtag < ApplicationRecord
  belongs_to :card_collection
  belongs_to :hashtag
end