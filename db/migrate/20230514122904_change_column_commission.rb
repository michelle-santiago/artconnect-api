class ChangeColumnCommission < ActiveRecord::Migration[7.0]
  def change
    change_column :commissions, :status, :string
    change_column :commissions, :log, :jsonb

  end
end
