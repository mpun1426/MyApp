class Spot < ApplicationRecord
  belongs_to :user
  has_many_attached :images
  MAX_IMAGES_COUNT = 4
  MAX_IMAGE_SIZE = 2

  validates :name, length: { in: 1..25 }
  validates :address, length: { in: 1..30 }
  validates :images, content_type: { in: ['image/jpeg', 'image/jpg', 'image/gif', 'image/png'],
            message: "対応ファイルは jpeg、jpg、gif、png です" },
            size: { less_than: MAX_IMAGE_SIZE.megabytes, message: "アップロードできるファイルサイズは#{ MAX_IMAGE_SIZE }MBまでです" },
            limit: { max: MAX_IMAGES_COUNT }
end
