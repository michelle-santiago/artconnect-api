class RenameLog < ActiveRecord::Migration[7.0]
  def change
    rename_column :commissions, :log, :process
  end
end
