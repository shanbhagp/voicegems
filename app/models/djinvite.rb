class Djinvite < ActiveRecord::Base
  attr_accessible :invite_type, :recipient_email, :recipient_name, :sender_email, :sender_name, :sent_at


  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :sender_email, presence:   true,
                    length: { maximum: 254 },
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :recipient_email, presence:   true,
                    length: { maximum: 254 },
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }


  
end
