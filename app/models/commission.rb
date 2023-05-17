class Commission < ApplicationRecord

  belongs_to :artist, class_name: "User"

  validates :kind, presence: true
  validates(:price, :duration, presence: true)


end
