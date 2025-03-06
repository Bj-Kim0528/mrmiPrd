class CreateCardImages < ActiveRecord::Migration[6.1]
  def change
    create_table :card_images do |t|
      t.references :card_collection, null: false, foreign_key: true
      t.text :content
      t.integer :position

      t.timestamps
    end
  end
end
