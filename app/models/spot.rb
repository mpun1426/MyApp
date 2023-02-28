class Spot < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many_attached :images
  MAX_IMAGES_COUNT = 4
  MAX_IMAGE_SIZE = 2

  validates :name, length: { in: 1..25 }
  validates :address, length: { in: 1..30 }
  validates :images, content_type: {
    in: ['image/jpeg', 'image/jpg', 'image/gif', 'image/png'],
    message: "の対応ファイルは jpeg、jpg、gif、png です",
  }
  validates :images, size: { less_than: MAX_IMAGE_SIZE.megabytes, message: "ファイルのサイズは1枚につき#{MAX_IMAGE_SIZE}MBまでです" }
  validates :images, limit: { max: MAX_IMAGES_COUNT, message: "をアップロードできるのは#{MAX_IMAGES_COUNT}枚までです" }
end
