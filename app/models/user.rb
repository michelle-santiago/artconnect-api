class User < ApplicationRecord
    has_secure_password
    validates :username, uniqueness: {case_sensitive: false}, presence: true
    validates :email, uniqueness: {case_sensitive: false}, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP } 
    validates :password, presence: true, length: { in: 6..20 }, unless: -> { password.blank? }
    validates(:first_name, :last_name, :role, presence: true)
end
