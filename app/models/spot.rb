class Spot < ApplicationRecord
  belongs_to :user

  validates :name, length: {in: 1..25}
end
