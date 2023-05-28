class Request < ApplicationRecord

  belongs_to :client, class_name: "User"
  belongs_to :artist, class_name: "User"

  has_many   :messages, foreign_key: "request_id", class_name: "Message"

  validates(:kind, :price, :duration, :status, :payment_status, presence: true)
  
end
