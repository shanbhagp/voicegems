module EventsHelper

#def generate_event_code(x)
#	x.event_code = Digest::SHA1.hexdigest.([Time.now, rand].join)[4..8]
#	if Event.find_by_event_code(x.event_code)
#		generate_event_code(x)
#	end 
#end

#def generate_event_code(x)
#	y = Digest::SHA1.hexdigest.([Time.now, rand].join)[4..8]
#	if Event.find_by_event_code(y)
#		generate_event_code(x)
#	else
#		x.event_code = y
#	end 
# end


# def generate_event_code(x)
#	x.event_code = Digest::SHA1.hexdigest([Time.now, rand].join)[4..8]
# end 

def generate_event_code(x)
	y = Digest::SHA1.hexdigest([Time.now, rand].join)[4..8].upcase

	if Event.find_by_event_code(y)
		generate_event_code(x)
	else
		x.event_code = y
	end 
end 

def owner_has_active_subscription?
    @event = Event.find(params[:id])
    if !@event.customerkeys.nil?
    		@customer = User.find_by_id(@event.customerkeys.first.user_id)
    		!@customer.subscriptions.nil? && @customer.subscriptions.any? {|s| s.active == true }  
    else
    	return false 
    end

end 

def page_is_active?
	@event = Event.find(params[:id])
	owner_has_active_subscription? || @event.purchase_type == 'p'
end 

def active_page_check
	unless page_is_active?
	  redirect_to current_user
      flash[:error] = "Inactive Event Page: the customer who created the event page for #{@event.title} has an inactive subscription to our service.  Please contact NameCoach or the customer (#{User.find_by_id(@event.customerkeys.first.user_id).email}) with any questions."
    end 
end 

end 