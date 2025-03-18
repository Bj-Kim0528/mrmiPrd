class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :card_collection

  validates :user_id, uniqueness: { scope: :card_collection_id }
end
