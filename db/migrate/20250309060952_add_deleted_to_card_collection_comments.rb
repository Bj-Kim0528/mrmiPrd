class AddDeletedToCardCollectionComments < ActiveRecord::Migration[6.1]
  def change
    add_column :card_collection_comments, :deleted, :boolean, default: false, null: false
  end
end
