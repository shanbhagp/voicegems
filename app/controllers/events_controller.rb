class EventsController < ApplicationController
	before_filter :signed_in_user
	before_filter :correct_admin_or_user, only: [:show]
	before_filter :correct_admin, only: [:edit]
	before_filter :active_page_check, only: [:show]

    before_filter :owner, only: [:index, :destroy]

	#def new
	#	 @event = Event.new  
	#end
	# this action is now no longer used, as the form is embedded in the user's (customer's) show page

	def create
	     @event = Event.new(params[:event])
	     @user = current_user

	     if  @event.purchase_type == 's'
	     	 if customer_has_active_subscription? && sub_pages_left > 0  #double-check to see if has some sub pages
		     	 # RUN MODIFIED FOR subscription events EXISTING CODE
	                 #generate the event_code 
	                 if @event.event_code.blank?
	                  generate_event_code(@event)
	                    if  @event.save  
	                    	#try decrementing s
            		          @s = current_user.subscriptions.select {|s| s.active == true}.first
					          @s.decrement(:events_remaining)
					          @s.increment(:events_used)
					          if @s.save
					          	 @event.customerkeys.create!(user_id: current_user.id)
	                    		 @event.adminkeys.create!(user_id: current_user.id)
	                     		 redirect_to @event, notice: "Welcome to your event page for #{@event.title}."
					          else #should't happen because subscription should save
					            flash[:error] = 'Something went wrong.  Please try again or contact tech support.'
					            redirect_to current_user
					          end  
					        # end try decrementing s
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
		                    	#try decrementing s
	            		          @s = current_user.subscriptions.select {|s| s.active == true}.first
						          @s.decrement(:events_remaining)
						          @s.increment(:events_used)
						          if @s.save
						          	 @event.customerkeys.create!(user_id: current_user.id)
		                    		 @event.adminkeys.create!(user_id: current_user.id)
		                     		 redirect_to @event, notice: "Welcome to your event page for #{@event.title}."
						          else #should't happen because subscription should save
						            flash[:error] = 'Something went wrong.  Please try again or contact tech support.'
						            redirect_to current_user
						          end  
						        # end try decrementing s
	                      	else
	                      	redirect_to current_user, notice: 'Please enter a title and date for your event.'
	                      	end
	                end 
	              end 
	             #END RUN MODIFIED for subscription events EXISTING CODE

	     	 else #shouldn't happen because event creation well shouldn't allow incoming s event_type if no s pages are left
	     	 	flash[:error] = 'No event pages remaining.  Please purchase more.'
	     	 	redirect_to current_user
	     	 end 
	     else
	     	if @event.purchase_type == 'p'
	     		if @user.purchased_events > 0
			     	     # RUN MODIFIED for purchased events EXISTING CODE
		                 #generate the event_code 
		                 if @event.event_code.blank?
		                  generate_event_code(@event)
		                    if  @event.save  
		                    	# try decrementing p
		                    	 @user.decrement(:purchased_events)
           						 if @user.save
           						      @event.customerkeys.create!(user_id: current_user.id)
		                     		  @event.adminkeys.create!(user_id: current_user.id)
		                     		  redirect_to @event, notice: "Welcome to your event page for #{@event.title}."
								 else #shouldn't happen because @user should save
					                  flash[:error] = 'Something went wrong.  Please try again or contact tech support.'
					                  redirect_to current_user
           						 end 
           						 # END try decrementing p
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
			                    	# try decrementing p
			                    	 @user.decrement(:purchased_events)
	           						 if @user.save
	           						      @event.customerkeys.create!(user_id: current_user.id)
			                     		  @event.adminkeys.create!(user_id: current_user.id)
			                     		  redirect_to @event, notice: "Welcome to your event page for #{@event.title}."
									 else #shouldn't happen because @user should save
						                  flash[:error] = 'Something went wrong.  Please try again or contact tech support.'
						                  redirect_to current_user
	           						 end 
	           						 # END try decrementing p
		                      else
		                      redirect_to current_user, notice: 'Please enter a title and date for your event.'
		                      end
		                end 
		              end 
		             #END RUN MODIFIED for purchased pages EXISTING CODE


	     			
	     		else #shouldn't happen because event creation well shouldn't allow incoming p event_type if no p pages are left
	     			flash[:error] = 'No event pages remaining.  Please purchase more.'
	     	 		redirect_to current_user
	     		end
	     	else #this shouldn't happen, just a catch all in case an event_type comes in that isn't p or s
	     		flash[:error] = 'Something went wrong.  Please try again or contact tech support.'
	     		redirect_to current_user
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
