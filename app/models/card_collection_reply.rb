class CardCollectionReply < ApplicationRecord
  belongs_to :user
  belongs_to :card_collection_comment

  # 자기 참조 관계: 최상위 답글은 parent_reply가 nil입니다.
  belongs_to :parent_reply, class_name: "CardCollectionReply", optional: true
  has_many   :child_replies, class_name: "CardCollectionReply", foreign_key: "parent_reply_id", dependent: :destroy
  
  has_many :likes, as: :likeable, dependent: :destroy
  
  def deleted?
    self[:deleted]
  end
end
