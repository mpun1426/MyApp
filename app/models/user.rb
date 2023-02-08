class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :spots
  mount_uploader :avatar, AvatarUploader
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  validates :nickname, presence: true

  def self.guest
    find_or_create_by!(email: 'guest@email.com') do |user|
      user.nickname = "ゲストユーザー"
      user.introduction = "ゲストユーザーです。"
      user.password = SecureRandom.urlsafe_base64
    end
  end
end
