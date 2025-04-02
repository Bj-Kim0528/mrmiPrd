class ReplaceThemeWithThemeIdInCardCollections < ActiveRecord::Migration[6.1]
  def change
    # 기존 theme 칼럼 제거
    remove_column :card_collections, :theme, :string

    # theme_id 칼럼 추가 (필수 여부에 따라 optional 설정할 수 있음)
    add_column :card_collections, :theme_id, :integer

    # 인덱스와 외래키 추가 (테마 테이블과 연결)
    add_index :card_collections, :theme_id
    add_foreign_key :card_collections, :themes
  end
end
