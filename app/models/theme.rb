class Theme < ApplicationRecord
    # 테마 이름은 반드시 존재해야 하고, 중복되지 않아야 합니다.
    validates :name, presence: true, uniqueness: { case_sensitive: false }

    # 카드콜렉션과 1:N 관계 (추후 CardCollection 모델에서 외래키를 추가할 예정)
    has_many :card_collections, dependent: :nullify
end
