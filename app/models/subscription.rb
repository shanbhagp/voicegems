class Subscription < ActiveRecord::Base
  attr_accessible :active, :canceled_at, :customer_id, :email, :plan_id, :user_id, :explanation

  belongs_to :user

  validates :email,  length: { maximum: 254 }
  validates :plan_id,  length: { maximum: 254 }
  validates :customer_id,  length: { maximum: 254 }

  scope :active, where(active: true)


end
