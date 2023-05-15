class AddColumnsToCommissions < ActiveRecord::Migration[7.0]
  def change
    add_column :commissions, :artist_id, :integer
    add_column :commissions, :client_id, :integer
  end
end
