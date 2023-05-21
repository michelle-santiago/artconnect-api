class RemovePhaseAndRevisionToCommissions < ActiveRecord::Migration[7.0]
  def change
    remove_column :commissions, :phase
    remove_column :commissions, :revision
  end
end
