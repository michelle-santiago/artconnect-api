class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.string      :body
      t.string      :kind
      t.integer     :request_id
      t.integer     :commission_id
      t.integer     :sender_id
      t.integer     :receiver_id
      t.timestamps
    end
  end
end
