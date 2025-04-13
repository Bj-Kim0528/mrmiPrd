class RemovePhotoOrderFromCardCollections < ActiveRecord::Migration[6.1]
  def change
    remove_column :card_collections, :photo_order, :text
  end
end
