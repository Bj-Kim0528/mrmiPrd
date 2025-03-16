class AddParentReplyIdToCardCollectionReplies < ActiveRecord::Migration[6.1]
  def change
    add_column :card_collection_replies, :parent_reply_id, :integer
    add_index :card_collection_replies, :parent_reply_id
  end
end
