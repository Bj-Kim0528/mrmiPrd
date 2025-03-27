class MakeBookmarksPolymorphic < ActiveRecord::Migration[6.1]
  def change
    # 기존 컬럼 제거
    remove_column :bookmarks, :card_collection_id, :integer

    # polymorphic association을 위한 컬럼 추가
    add_column :bookmarks, :bookmarkable_type, :string, null: false, default: ""
    add_column :bookmarks, :bookmarkable_id, :integer, null: false

    # 인덱스 재설정
    add_index :bookmarks, [:user_id, :bookmarkable_type, :bookmarkable_id], unique: true, name: "index_bookmarks_on_user_and_bookmarkable"
    add_index :bookmarks, [:bookmarkable_type, :bookmarkable_id]
  end
end

