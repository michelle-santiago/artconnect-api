class CreateCommissions < ActiveRecord::Migration[7.0]
  def change
    create_table :commissions do |t|
      t.string   :kind
      t.decimal  :price
      t.string   :duration
      t.string   :status, array: true
      t.string   :phase, array: true
      t.json     :log
      t.timestamps
    end
  end
end
