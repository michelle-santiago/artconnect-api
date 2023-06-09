class Commission < ApplicationRecord

  belongs_to :artist, class_name: "User"
  belongs_to :client, class_name: "User", optional: true

  has_one_attached :image

  has_many   :messages, foreign_key: "commission_id", class_name: "Message"

  validates :kind, presence: true
  validates(:price, :duration, presence: true)

  def add_process!(process)
    if self.process.nil?
      self.process =  [{ phase: process[:phase], datetime: DateTime.now, p_price: process[:p_price], payment_status: process[:payment_status], remarks: process[:remarks], p_status: process[:p_status]}]
    else
      self.process.append({ phase: process[:phase], datetime: DateTime.now, p_price: process[:p_price], payment_status: process[:payment_status], remarks: process[:remarks], p_status: process[:p_status]})
    end
    self.save
  end
  
  def complete_process!
    self.process.last["p_status"] = "completed"
    self.save
  end

  def update_process!(process)
    self.process[ self.process.length - 1] = { phase: self.process.last["phase"], datetime: DateTime.now, p_price: process[:p_price], payment_status: process[:payment_status], remarks: process[:remarks], p_status: process[:p_status]}
    self.save
  end

end
