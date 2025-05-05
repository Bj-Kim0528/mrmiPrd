class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.references :conversation, null: false, foreign_key: true
      t.references :user,         null: false, foreign_key: true
      t.text       :content,      null: false
      t.timestamps
    end
    add_index :messages, :created_at
  end
end
