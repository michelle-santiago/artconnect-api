class AddImageUrltoCommission < ActiveRecord::Migration[7.0]
  def change
    add_column :commissions, :image_url, :string
  end
end
