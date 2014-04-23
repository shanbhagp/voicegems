class Coupon < ActiveRecord::Base
  attr_accessible :active, :duration, :duration_in_months, :free_page_name, :free_page_user, :max_redemptions, :name, :percent_off, :redeem_by, :times_redeemed, :cost, :promo_msg
  def self.percent_off_purchase(coupon) 
     where("free_page_name = ? and active = true and name = 'percent_off_purchase' and (redeem_by is null or redeem_by >= now() at time zone 'utc')", coupon).first
  end 
end
