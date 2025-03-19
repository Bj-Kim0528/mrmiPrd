class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  # 중복 팔로우를 방지하는 검증 (유니크 인덱스와 함께 사용)
  validates :follower_id, uniqueness: { scope: :followed_id }
end
