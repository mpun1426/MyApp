class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :spots, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_one_attached :avatar
  devise :database_authenticatable, :registerable, :rememberable, :validatable
  MAX_IMAGE_SIZE = 2

  def self.guest
    find_or_create_by!(email: 'guest@email.com') do |user|
      user.nickname = "ゲストユーザー"
      user.introduction = "ゲストユーザーです。"
      user.password = SecureRandom.urlsafe_base64
    end
  end

  validates :nickname, presence: true
  validates :email, presence: true
  validates :avatar, content_type: {
    in: ['image/jpeg', 'image/jpg', 'image/gif', 'image/png'],
    message: "の対応ファイルは jpeg、jpg、gif、png です",
  }
  validates :avatar, size: { less_than: MAX_IMAGE_SIZE.megabytes, message: "ファイルのサイズは1枚につき#{MAX_IMAGE_SIZE}MBまでです" }
end
