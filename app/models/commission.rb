class Commission < ApplicationRecord

  belongs_to :artist, class_name: "User"

  validates :kind, presence: true
  validates(:price, :duration, presence: true)

  def process_repeatable?(process)
    if process[:phase] == "revision"
      return true
    else
      self.process.any? { |p| p["phase"] != process[:phase] }
    end
  end

  def add_process!(process)
    print "length"
    if self.process.length < 1
      self.process =  [{ phase: process[:phase], datetime: DateTime.now, price: process[:p_price], payment_status: process[:payment_status], remarks: process[:remarks], status: process[:p_status]}]
    else
      self.process.append({ phase: process[:phase], datetime: DateTime.now, price: process[:p_price], payment_status: process[:payment_status], remarks: process[:remarks], status: process[:p_status]})
    end
    self.save
  end
  
  def complete_process!
    self.process.last["status"] = "completed"
    self.save
  end

  def update_process!(process)
    self.process[ self.process.length - 1] = { phase: self.process.last["phase"], datetime: DateTime.now, price: process[:p_price], payment_status: process[:payment_status], remarks: process[:remarks], status: process[:p_status]}
    self.save
  end

end
