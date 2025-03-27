class RemoveUserIdIndexFromBookmarks < ActiveRecord::Migration[6.1]
  def change
    if index_exists?(:bookmarks, :user_id, name: "index_bookmarks_on_user_id")
      remove_index :bookmarks, name: "index_bookmarks_on_user_id"
    end
  end
end
