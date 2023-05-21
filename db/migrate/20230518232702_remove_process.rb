class RemoveProcess < ActiveRecord::Migration[7.0]
  def change
    remove_column :commissions, :process
  end
end
