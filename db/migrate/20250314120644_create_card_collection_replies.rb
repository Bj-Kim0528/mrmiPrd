class CreateCardCollectionReplies < ActiveRecord::Migration[6.1]
  def change
    create_table :card_collection_replies do |t|
      t.text :comment
      t.integer :user_id
      t.integer :card_collection_comment_id
      t.boolean :deleted, default: false, null: false

      t.timestamps
    end

    add_index :card_collection_replies, :user_id
    add_index :card_collection_replies, :card_collection_comment_id
  end
end
