class Request < ApplicationRecord

  belongs_to :client, class_name: "User"

  validates(:kind, :price, :duration, presence: true)
  
end
