class CreateRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :requests do |t|
      t.string   :kind
      t.decimal  :price
      t.string   :duration
      t.string   :status, default: "pending"
      t.string   :payment_status, default: "unpaid"
      t.integer  :client_id
      t.integer  :artist_id
      t.timestamps
    end
  end
end
