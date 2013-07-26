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
	unless current_user.email == 'shanbhagp@aol.com' || page_is_active?
	  redirect_to current_user
      flash[:error] = "Inactive Event Page: the customer who created the event page for #{@event.title} has an inactive subscription to our service.  Please contact NameCoach or the customer (#{User.find_by_id(@event.customerkeys.first.user_id).email}) with any questions."
    end 
end 

#what is this doing? are we ever using the event's event_type?  YES - in event show pages
def assign_event_type(event)

	  event.event_type = current_user.event_type
	  if event.master == true
	  	event.event_type = 'students'
	  end 
	
end 

def student_event?
	current_user.event_type == 'students' || current_user.event_type == 'graduation' || current_user.event_type == 
	'commencement' || current_user.event_type == 'all_inclusive'
end 

def create_default_grad_page(event)
	if event.master == true
	 	@event = Event.new(:event_type => 'commencement', :tite => "Graduation: #{event.title}", :date => event.date)
	 	generate_event_code(@event)
	 	@event.save
	 	#create and admin and customer key for this event
	end 
end 

end 