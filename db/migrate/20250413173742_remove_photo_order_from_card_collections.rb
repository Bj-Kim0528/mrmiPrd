class RemovePhotoOrderFromCardCollections < ActiveRecord::Migration[6.1]
  def change
    if column_exists?(:card_collections, :photo_order)
      remove_column :card_collections, :photo_order, :text
    end
  end
end
