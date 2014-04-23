class AddPromoMessageToCoupon < ActiveRecord::Migration
  def change
    add_column :coupons, :promo_msg, :string
  end
end
