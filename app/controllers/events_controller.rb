class EventsController < ApplicationController
	before_filter :signed_in_user
	before_filter :correct_admin_or_user, only: [:show]
	before_filter :correct_admin, only: [:edit]
	before_filter :has_active_customer, only: [:show]

    before_filter :owner, only: [:index, :destroy]

	#def new
	#	 @event = Event.new  
	#end
	# this action is now no longer used, as the form is embedded in the user's (customer's) show page

	def create
	     @event = Event.new(params[:event])
	     
	     #generate the event_code 
	     if @event.event_code.blank?
	     	generate_event_code(@event)
	     		if  @event.save  
			     @event.customerkeys.create!(user_id: current_user.id)
			     @event.adminkeys.create!(user_id: current_user.id)
			     redirect_to @event, notice: "Welcome to your event page for #{@event.title}."
			 	else
			 	flash[:error] = 'Please enter a title and date for your event.'
			 	redirect_to current_user
			 	end

	     else
	     	if Event.find_by_event_code(@event.event_code.upcase.delete(' '))
			         redirect_to current_user, notice: "This event code,#{@event.event_code.upcase.delete(' ')}, has already been taken. Please choose another."
		    else 
			     		e = @event.event_code.upcase.delete(' ')
			     		@event.event_code = e 
					    if  @event.save  
					     @event.customerkeys.create!(user_id: current_user.id)
					     @event.adminkeys.create!(user_id: current_user.id)
					     redirect_to @event, notice: "Welcome to your event page for #{@event.title}."
					 	else
					 	redirect_to current_user, notice: 'Please enter a title and date for your event.'
					 	end
		 	end 
	 	end 
	end

	def show
		 @event = Event.find(params[:id])
		 @practiceobject = Practiceobject.new  
		 @practiceobject.event_id = @event.id #for the form_for(@practiceobject) which creatse a new practice object (and another form which just shows the labels - can find a better way for that)
		 @registeredandrecordedpos = @event.practiceobjects.registered.recorded.visible
		 @registeredandunrecordedpos = @event.practiceobjects.registered.unrecorded.visible
		 @unregisteredpos = @event.practiceobjects.unregistered.visible
		 @hiddenpos = @event.practiceobjects.hidden
		 @hiddenandregisteredpos  = @hiddenpos.registered
		 @hiddenandunregisteredpos = @hiddenpos.unregistered  

    end

	def index
    @events = Event.all
  end

  def edit
  	@event = Event.find(params[:id])
  	
  end 


  def update
    @event = Event.find(params[:id])
    
    @event.title = params[:event][:title]
    @event.date = params[:event][:date]

    if params[:event][:event_code].blank? 
    	generate_event_code(@event)
 		if  @event.save  
 		  flash[:success] =  "Your event details were updated."
	      redirect_to @event
	 	else
	 	 flash[:error] = 'Please make sure both a title and date are entered for your event.'
	 	 redirect_to edit_event_path(@event)
	 	end
    else
		if Event.find_by_event_code(params[:event][:event_code].upcase.delete(' ')) && !(Event.find_by_event_code(params[:event][:event_code].upcase.delete(' ')).id == @event.id)
			flash[:error] = "This event code, #{params[:event][:event_code].upcase.delete(' ')}, has already been taken. Please choose another."
		    redirect_to edit_event_path(@event)
		else 
     		@event.event_code = params[:event][:event_code].upcase.delete(' ') 
		    if  @event.save 
		     flash[:success] = "Your event details were updated."
		     redirect_to @event
		 	else
		 	  flash[:error] = 'Please make sure both a title and date are entered for your event.'
	 	      redirect_to edit_event_path(@event)
		 	end
		end 

    end 


  end


 def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end

end
