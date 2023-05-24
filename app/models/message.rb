class Message < ApplicationRecord

  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"
  belongs_to :commission, class_name: "Commission", optional: true
  belongs_to :request, class_name: "Request", optional: true

  validates(:kind, :body, :sender_id, :receiver_id, presence: true)
end
