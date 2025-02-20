class RenameContentToContentsInCardCollections < ActiveRecord::Migration[6.1]
  def change
    rename_column :card_collections, :content, :contents
  end
end
