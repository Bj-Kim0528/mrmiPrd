class AddViewCountToCardCollections < ActiveRecord::Migration[6.1]
  def change
    add_column :card_collections, :view_count, :integer, default: 0, null: false
  end
end