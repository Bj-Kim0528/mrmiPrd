class AddParentCommentIdToCardCollectionComments < ActiveRecord::Migration[6.1]
  def change
    add_column :card_collection_comments, :parent_comment_id, :integer
    add_index :card_collection_comments, :parent_comment_id
  end
end
