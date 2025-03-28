class RemoveContentsFromCardCollections < ActiveRecord::Migration[6.1]
  def change
    remove_column :card_collections, :contents, :text
  end
end