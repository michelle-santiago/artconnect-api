class AddProcess < ActiveRecord::Migration[7.0]
  def change
    add_column :commissions, :process, :jsonb, array: true
  end
end
