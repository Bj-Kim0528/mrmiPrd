class CreateCardCollectionHashtags < ActiveRecord::Migration[6.1]
  def change
    create_table :card_collection_hashtags do |t|
      t.references :card_collection, null: false, foreign_key: true
      t.references :hashtag, null: false, foreign_key: true

      t.timestamps
    end

    add_index :card_collection_hashtags, [:card_collection_id, :hashtag_id], unique: true, name: "index_card_collection_hashtags_on_card_collection_and_hashtag"
  end
end
