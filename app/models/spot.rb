class Spot < ApplicationRecord
  belongs_to :user
  has_many_attached :images

  validates :name, length: {in: 1..25}
  validates :address, length: {in: 1..30}
  validates :images, content_type: { in: ['image/jpeg', 'image/jpg', 'image/gif', 'image/png'],
            message: "有効なフォーマットではありません" },
            size: { less_than: 5.megabytes, message: "5MBを超える画像はアップロードできません" }
end
