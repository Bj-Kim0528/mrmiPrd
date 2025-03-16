class RemoveParentCommentIdFromCardCollectionComments < ActiveRecord::Migration[6.1]
  def change
    remove_index :card_collection_comments, :parent_comment_id if index_exists?(:card_collection_comments, :parent_comment_id)
    remove_column :card_collection_comments, :parent_comment_id, :integer
  end
end
