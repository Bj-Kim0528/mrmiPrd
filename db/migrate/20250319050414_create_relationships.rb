class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|
      t.integer :follower_id, null: false
      t.integer :followed_id, null: false

      t.timestamps
    end

    # 한 사용자가 같은 사용자를 중복으로 팔로우하지 못하도록 유니크 인덱스 추가
    add_index :relationships, [:follower_id, :followed_id], unique: true
    # 각각의 사용자에 대한 조회를 빠르게 하기 위한 인덱스
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
  end
end
