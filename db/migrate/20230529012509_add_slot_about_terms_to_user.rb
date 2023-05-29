class AddSlotAboutTermsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :max_slot, :integer, default: 5
    add_column :users, :about, :text
    add_column :users, :terms, :text
  end
end
