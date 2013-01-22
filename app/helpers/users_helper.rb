module UsersHelper

   #these two methods are copied from the sample app; the method is called in the views
  def wrap(content)
      unless content.nil?
    	sanitize(raw(content.split.map{ |s| wrap_long_string(s) }.join(' ')))
      end 
  end

  private

    def wrap_long_string(text, max_width = 20)
      zero_width_space = "&#8203;"
      regex = /.{1,#{max_width}}/
      (text.length < max_width) ? text : 
                                  text.scan(regex).join(zero_width_space)
    end

    def create_customer(token, plan)

        # create a Customer
        customer = Stripe::Customer.create(
          :card => token,
          :plan => plan,
          :description => "#{current_user.first_name} #{current_user.last_name}",
          :email => current_user.email
        )

        if !customer.nil?
          current_user.update_attributes(:customer_id => customer.id, :customer => true, :admin => true)
         # will have to change this to calculated adjusted ER's for when a customer canceled a previous subscription
         #except this is for new users, so probalby won't have to do this
          if Plan.find_by_name(plan) #to prevent a nil problem
            @er = Plan.find_by_name(plan).events_number
          else 
            @er = 0 #just so @er not undefined - will probably need to change this if-else-end code to be more elegant
          end 
          @sub = Subscription.new(:user_id => current_user.id, :email => current_user.email, :customer_id => customer.id, :plan_id => plan, :active => true)
          @sub.events_remaining = @er
          @sub.save 
          flash[:success] = "Thank you for subscribing!  You can now create an event page, from which you can 1) invite attendees to record their names, 2) hear those recordings, and 3) invite other admins."
        else
          flash.now[:error] = "Something went wrong, please try again."
          false 
        end
        
        rescue Stripe::InvalidRequestError => e
         logger.error "Stripe error while creating customer: #{e.message}"
         flash.now[:error] = "There was a problem processing your credit card. #{e.message}.  Please try again."
         false
       
        rescue Stripe::CardError => e
         logger.error "Stripe error while creating customer: #{e.message}"
         flash.now[:error] = "There was a problem processing your credit card. #{e.message}. Please try again."
         false

         rescue Stripe::StripeError => e
         logger.error "Stripe error while creating customer: #{e.message}"
         flash.now[:error] = "There was a problem processing your credit card. #{e.message}.  Please try again."
         false

         
         
    end 


    def temp_password(token)
       @user.password=token
       @user.password_confirmation= token
    end 


    def customer_has_active_subscription?
        !current_user.subscriptions.nil? && current_user.subscriptions.any? {|s| s.active == true }  
    end

    # for a before_filter
    def customer_has_no_active_subscription
     if customer_has_active_subscription?
      redirect_to current_user
      flash[:notice] = "You already have an active subscription to our service."
     end 
    end 

    def active_sub_with_events_left?
       customer_has_active_subscription? && current_user.subscriptions.select {|s| s.active == true}.first.events_remaining > 0 
    end 

    def only_sub_pages_left?
      active_sub_with_events_left? && current_user.purchased_events <= 0
    end

    def only_purch_pages_left? 
          !active_sub_with_events_left? && current_user.purchased_events > 0
    end 

    def purch_and_sub_pages_left?
       active_sub_with_events_left? && current_user.purchased_events > 0
    end 

    def no_pages_left?
      !active_sub_with_events_left? && current_user.purchased_events <= 0
    end 
    # do I need to account for possible negative numbes for purchased_events?  will try to prevent decrementing below zero in the code
    # changed from == to <= just to make sure the wells don't disappear if have a subscription but somehow purchased events falls below zero

    def sub_pages_left
      current_user.subscriptions.select {|s| s.active == true}.first.events_remaining
    end 
    # shouldn't get nil object problem as long as I only call this in situations whre customer_has_active_subscription? = true
    # using first even though should be only one active subscription per user

    def has_trialed?
       current_user.subscriptions.any? {|s| !s.canceled_at.nil? && s.canceled_at > s.created_at + 13.days }
    end 

    def has_not_trialed?
      !has_trialed? 
    end 

    # for non-subscroption/by-the-event-page purchases
    def create_customer_purchase(token, number)

    if number.to_i < 6 
       @cost = number.to_i*35 
    end 
    if number.to_i > 5 && number.to_i < 11 
       @cost = number.to_i*30 
    end 
    if number.to_i > 10 
       @cost = number.to_i*25 
    end 
        # create a Customer
        customer = Stripe::Customer.create(
          :card => token,
          :description => "#{current_user.first_name} #{current_user.last_name}",
          :email => current_user.email
        )

        # charge the Customer instead of the card
        Stripe::Charge.create(
            :amount => @cost.to_i*100, # in cents
            :currency => "usd",
            :customer => customer.id,
            :description => "#{number} pages"
        )

        if !customer.nil?
          current_user.update_attributes(:customer_id => customer.id, :customer => true, :admin => true)
          @eventtotal = current_user.purchased_events + number.to_i
          current_user.purchased_events = @eventtotal
          current_user.save
          flash[:success] = "Thank you for your purchase!  You can now create an event page, from which you can 1) invite attendees to record their names, 2) hear those recordings, and 3) invite other admins."
        else
          flash.now[:error] = "Something went wrong, please try again."
          false 
        end
        
        rescue Stripe::InvalidRequestError => e
         logger.error "Stripe error while creating customer: #{e.message}"
         flash.now[:error] = "There was a problem processing your credit card. #{e.message}. Please try again."
         false
       
        rescue Stripe::CardError => e
         logger.error "Stripe error while creating customer: #{e.message}"
         flash.now[:error] = "There was a problem processing your credit card. #{e.message}. Please try again."
         false

         rescue Stripe::StripeError => e
         logger.error "Stripe error while creating customer: #{e.message}"
         flash.now[:error] = "There was a problem processing your credit card. #{e.message}.  Please try again."
         false

         
         
    end 


    # for a customer changing their subscription (for stripereceiver_existing action)
    def update_card_and_subscription(token, plan)
      
      c = Stripe::Customer.retrieve(current_user.customer_id)  #have this in the enveloping controller action as well, because of the 'undefined variable c' error i was getting from the 4000000000000341 card test

      #updates customer with new card
      c.card = token
      c.save

      #updates subscription plan in stripe 
      c.update_subscription(:plan => plan, :prorate => true)

        rescue Stripe::InvalidRequestError => e
         logger.error "Stripe error while creating customer: #{e.message}"
         flash[:error] = "There was a problem processing your credit card. #{e.message}. Please try again."
         false
       
        rescue Stripe::CardError => e
         logger.error "Stripe error while creating customer: #{e.message}"
         flash[:error] = "There was a problem processing your credit card. #{e.message}. Please try again."
         false

         rescue Stripe::StripeError => e
         logger.error "Stripe error while creating customer: #{e.message}"
         flash[:error] = "There was a problem processing your credit card. #{e.message}. Please try again."
         false

   end 

# for the purchase_sub_new_card action (stripe customer w/o active sub buying a sub)
  def update_card_and_new_subscription(token, plan)
      #should be a customer_id b/c downstream from option in which user has an existing stripe customer id
      c = Stripe::Customer.retrieve(current_user.customer_id)
 

      #updates customer with new card
      c.card = token
      c.save

      #create subscription for this customer in stripe (note that update_subscription creates a new subscription for this customer in this case)
      if has_not_trialed?
      c.update_subscription(:plan => plan)
      else
      c.update_subscription(:plan => plan, :trial_end => (Date.today + 1.day).to_time.to_i)
      end 

       rescue Stripe::InvalidRequestError => e
         logger.error "Stripe error while creating customer: #{e.message}"
         flash[:error] = "There was a problem processing your credit card. #{e.message}. Please try again."
         false
       
        rescue Stripe::CardError => e
         logger.error "Stripe error while creating customer: #{e.message}"
         flash[:error] = "There was a problem processing your credit card. #{e.message}. Please try again."
         false

         rescue Stripe::StripeError => e
         logger.error "Stripe error while creating customer: #{e.message}"
         flash[:error] = "There was a problem processing your credit card. #{e.message}. Please try again."
         false

  end  

def existing_customer_purchase_events_existing_card(number)
     
     if number.to_i < 6 
       @cost = number.to_i*35 
     end 

     if number.to_i > 5 && number.to_i < 11 
       @cost = number.to_i*30 
     end 

     if number.to_i > 10 
       @cost = number.to_i*25 
     end

       c = Stripe::Customer.retrieve(current_user.customer_id)
     
        # charge the Customer instead of the card
        Stripe::Charge.create(
            :amount => @cost.to_i*100, # in cents
            :currency => "usd",
            :customer => c.id,
            :description => "#{number} pages"
        )

        
          @eventtotal = current_user.purchased_events + number.to_i
          current_user.purchased_events = @eventtotal
          current_user.save
         
        
        rescue Stripe::InvalidRequestError => e
         logger.error "Stripe error while creating customer: #{e.message}"
         flash[:error] = "There was a problem processing your credit card. #{e.message}.  Please try again."
         false
       
        rescue Stripe::CardError => e
         logger.error "Stripe error while creating customer: #{e.message}"
         flash[:error] = "There was a problem processing your credit card. #{e.message}. Please try again."
         false

         rescue Stripe::StripeError => e
         logger.error "Stripe error while creating customer: #{e.message}"
         flash[:error] = "There was a problem processing your credit card. #{e.message}. Please try again."
         false

end 

def update_card_and_purchase(token, number)
     if number.to_i < 6 
       @cost = number.to_i*35 
     end 

     if number.to_i > 5 && number.to_i < 11 
       @cost = number.to_i*30 
     end 

     if number.to_i > 10 
       @cost = number.to_i*25 
     end

     #should be a customer_id b/c downstream from option in which user has an existing stripe customer id
      c = Stripe::Customer.retrieve(current_user.customer_id)
 
      #updates customer with new card
      c.card = token
      c.save

      #create new charge for these event pages
        Stripe::Charge.create(
            :amount => @cost.to_i*100, # in cents
            :currency => "usd",
            :customer => c.id,
            :description => "#{number} pages"
        )
     
        #update purchased_events in my database
          @eventtotal = current_user.purchased_events + number.to_i
          current_user.purchased_events = @eventtotal
          current_user.save

       rescue Stripe::InvalidRequestError => e
         logger.error "Stripe error while creating customer: #{e.message}"
         flash[:error] = "There was a problem processing your credit card. #{e.message}. Please try again."
         false
       
        rescue Stripe::CardError => e
         logger.error "Stripe error while creating customer: #{e.message}"
         flash[:error] = "There was a problem processing your credit card. #{e.message}. Please try again."
         false

         rescue Stripe::StripeError => e
         logger.error "Stripe error while creating customer: #{e.message}"
         flash[:error] = "There was a problem processing your credit card. #{e.message}. Please try again."
         false

end 

def create_customer_and_purchase_existing_user(token, number)# this is almost like create_customer_purchase, except have flash.nows in that helper

   if number.to_i < 6 
       @cost = number.to_i*35 
    end 
    if number.to_i > 5 && number.to_i < 11 
       @cost = number.to_i*30 
    end 
    if number.to_i > 10 
       @cost = number.to_i*25 
    end 
        # create a Customer
        customer = Stripe::Customer.create(
          :card => token,
          :description => "#{current_user.first_name} #{current_user.last_name}",
          :email => current_user.email
        )

        # charge the Customer instead of the card
        Stripe::Charge.create(
            :amount => @cost.to_i*100, # in cents
            :currency => "usd",
            :customer => customer.id,
            :description => "#{number} pages"
        )

        if !customer.nil?
          current_user.update_attributes(:customer_id => customer.id, :customer => true, :admin => true)
          @eventtotal = current_user.purchased_events + number.to_i
          current_user.purchased_events = @eventtotal
          current_user.save
          flash[:success] = "Thank you for your purchase!  You can now create an event page, from which you can 1) invite attendees to record their names, 2) hear those recordings, and 3) invite other admins."
        else
          flash[:error] = "Something went wrong, please try again."
          false 
        end
        
        rescue Stripe::InvalidRequestError => e
         logger.error "Stripe error while creating customer: #{e.message}"
         flash[:error] = "There was a problem processing your credit card. #{e.message}. Please try again."
         false
       
        rescue Stripe::CardError => e
         logger.error "Stripe error while creating customer: #{e.message}"
         flash[:error] = "There was a problem processing your credit card. #{e.message}. Please try again."
         false

         rescue Stripe::StripeError => e
         logger.error "Stripe error while creating customer: #{e.message}"
         flash[:error] = "There was a problem processing your credit card. #{e.message}. Please try again."
         false


end 

end
