class RemoveOldBookmarkIndex < ActiveRecord::Migration[6.1]
  def change
    if index_exists?(:bookmarks, :user_id, name: "index_bookmarks_on_user_id_and_card_collection_id")
      remove_index :bookmarks, name: "index_bookmarks_on_user_id_and_card_collection_id"
    end
  end
end