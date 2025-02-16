class CreateCardCollections < ActiveRecord::Migration[6.1]
  def change
    create_table :card_collections do |t|
      t.references :user, null: false, foreign_key: true  # 게시글 작성자 (User와의 연관)
      t.text :content                                      # 게시글 본문 내용
      t.string :layout                              # 공간정보 (예: "원룸", "거실", "주방")
      t.string :theme                                      # 테마/카테고리 분류용
      
      t.timestamps
    end
  end
end
