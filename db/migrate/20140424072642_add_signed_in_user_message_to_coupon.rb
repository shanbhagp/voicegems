class AddSignedInUserMessageToCoupon < ActiveRecord::Migration
  def change
    add_column :coupons, :signed_in_promo_msg, :string
  end
end
