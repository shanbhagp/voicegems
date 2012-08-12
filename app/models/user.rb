class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :notes, :password, :password_confirmation, :phonetic, :recording
  has_secure_password


  
  before_save { self.email.downcase! }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  before_save :create_remember_token


  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
    
end

# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  first_name      :string(255)
#  last_name       :string(255)
#  password_digest :string(255)
#  email           :string(255)
#  remember_token  :string(255)
#  recording       :string(255)
#  phonetic        :string(255)
#  notes           :string(255)
#  admin           :boolean
#  customer        :boolean
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

