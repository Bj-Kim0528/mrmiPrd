class AddImageUrlToTags < ActiveRecord::Migration[6.1]
  def change
    add_column :tags, :image_url, :string
  end
end
