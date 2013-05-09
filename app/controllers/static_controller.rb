class StaticController < ApplicationController

def value
end 

def works
end 

def plantest
end

def terms
end

def cartest
end 

def weddings

	@first_plan = Plan.find_by_my_plan_id(plan_set_one) # sets @first_plan the first plan object ACCORDING TO MY LEGEND (with my_plan_id)
	@second_plan = Plan.find_by_my_plan_id(plan_set_two)
	@third_plan = Plan.find_by_my_plan_id(plan_set_three)

end 

def privacy
end 

def faq
end 

def graduations
	  @event = Event.find(ENV['demopage'].to_i)

  	 @practiceobject = Practiceobject.new  
	 @practiceobject.event_id = @event.id #for the form_for(@practiceobject) which creatse a new practice object (and another form which just shows the labels - can find a better way for that)
	 @registeredandrecordedpos = @event.practiceobjects.registered.recorded.visible
	 @registeredandunrecordedpos = @event.practiceobjects.registered.unrecorded.visible
	 @unregisteredpos = @event.practiceobjects.unregistered.visible
	 @hiddenpos = @event.practiceobjects.hidden
	 @hiddenandregisteredpos  = @hiddenpos.registered
	 @hiddenandunregisteredpos = @hiddenpos.unregistered  

	 @url = demo_record_url(:event_code => @event.event_code)
end 

end