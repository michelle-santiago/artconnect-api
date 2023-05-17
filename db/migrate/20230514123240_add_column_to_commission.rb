class AddColumnToCommission < ActiveRecord::Migration[7.0]
  def change
    add_column :commissions, :revision, :jsonb
  end
end
