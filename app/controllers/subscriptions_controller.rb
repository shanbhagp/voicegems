class SubscriptionsController < ApplicationController
before_filter :owner, only: [:index]

#shows the cancel subscription page
def cancel
@subs = current_user.subscriptions 
	if @subs && !@subs.active.blank?
	@s = @subs.active.first
	@s_end = @s.created_at + 14.days
	#@c = Stripe::Customer.retrieve(@s.customer_id)
	else #this should not happen - be careful to make sure every customer has a subscription; or at least if they have a 
		# cancel subsciption link, there is an active subscription to be canceled. 
	redirect_to current_user, notice: 'You have no active subscriptions.'
	end 
end 

#actually cancels the subscription
def unsubscribe
	@sub = Subscription.find_by_id(params[:c][:sub_id])
	@sub.update_attributes(:explanation => params[:c][:explanation], :active => false, :canceled_at => Time.now)
	current_user.update_attributes(:customer => false)
	@cust = Stripe::Customer.retrieve(current_user.customer_id)
	@cust.cancel_subscription
	redirect_to current_user, notice: "Thank you for trying our service!"
end 

def index
@subs = Subscription.all
end

end
