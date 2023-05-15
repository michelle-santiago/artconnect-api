class User < ApplicationRecord

	has_secure_password

	has_many  :commissions, foreign_key: "artist_id", class_name: "Commission"
	has_many  :requests, foreign_key: "client_id", class_name: "Request"

	validates :username, uniqueness: { case_sensitive: false }, presence: true
	validates :email, uniqueness: { case_sensitive: false }, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP } 
	validates :password, presence: true, length: { in: 6..20 }, unless: -> { password.blank? }
	validates(:first_name, :last_name, :role, presence: true)

end
