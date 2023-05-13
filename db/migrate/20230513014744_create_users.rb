class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string  :first_name
      t.string  :last_name
      t.string  :email
      t.string  :username
      t.string  :password_digest
      t.string  :token
      t.string :role
      t.boolean :email_confirmed, default: false
      t.string  :password_reset_token
      t.integer :verification_code
      t.timestamps
    end
  end
end
