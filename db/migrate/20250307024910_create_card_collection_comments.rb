class CreateCardCollectionComments < ActiveRecord::Migration[6.1]
  def change
    create_table :card_collection_comments do |t|
      t.text :comment
      t.integer :user_id
      t.integer :card_collection_id

      t.timestamps
    end
  end
end
