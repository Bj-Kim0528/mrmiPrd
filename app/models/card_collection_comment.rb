class CardCollectionComment < ApplicationRecord
  belongs_to :user
  belongs_to :card_collection

  has_many :card_collection_replies, dependent: :destroy

  has_many :likes, as: :likeable, dependent: :destroy

  
  validates :comment, presence: true, unless: :deleted?

  def deleted?
    self[:deleted]
  end
end
