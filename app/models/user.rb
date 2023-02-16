class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :spots
  has_one_attached :avatar
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  def self.guest
    find_or_create_by!(email: 'guest@email.com') do |user|
      user.nickname = "ゲストユーザー"
      user.introduction = "ゲストユーザーです。"
      user.password = SecureRandom.urlsafe_base64
    end
  end

  validates :nickname, presence: true
end
