class AddPromoCouponToUsers < ActiveRecord::Migration
  def change
    add_column :users, :promo_coupon, :string
  end
end
