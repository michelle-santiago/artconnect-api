class AddImageUrltoRequest < ActiveRecord::Migration[7.0]
  def change
    add_column :requests, :image_url, :string
  end
end
