class Commission < ApplicationRecord

  belongs_to :artist, class_name: "User"

  validates :kind, presence: true
  validates(:price, :duration, presence: true)


  def add_process!
    self.status = "in progress"
    self.phase =  "sketch"
    self.process =  [{ phase: "sketch", datetime: DateTime.now, price: nil, payment_status: nil, remarks: nil, status: "pending" }]
    self.save
  end

  
  def update_process!(process_params)
    self.phase =  process_params[:phase]
    self.process.append({ phase: process_params[:phase], datetime: DateTime.now, price: process_params[:revision_price], payment_status: "unpaid", remarks: process_params[:remarks], status: "pending" })
    self.save
  end
end
