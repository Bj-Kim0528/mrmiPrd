class ReplaceThemeWithThemeIdInCardCollections < ActiveRecord::Migration[6.1]
  def change
    if column_exists?(:card_collections, :theme)
      remove_column :card_collections, :theme, :string
    end

    # theme_id 칼럼 추가 (이미 존재하지 않는다면 추가)
    unless column_exists?(:card_collections, :theme_id)
      add_column :card_collections, :theme_id, :integer
    end
    # 인덱스와 외래키 추가 (테마 테이블과 연결)
    unless index_exists?(:card_collections, :theme_id)
      add_index :card_collections, :theme_id
    end
  end
end
