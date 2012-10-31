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
          @sub = Subscription.new(:user_id => current_user.id, :email => current_user.email, :customer_id => customer.id, :plan_id => plan, :active => true)
          @sub.save 
          flash[:success] = "Thank you for subscribing!  You can now create an event page, from which you can 1) invite attendees to record their names, 2) hear those recordings, and 3) invite other admins."
        else
          flash.now[:error] = "Something went wrong, please try again."
          false 
        end
        
        rescue Stripe::InvalidRequestError => e
         logger.error "Stripe error while creating customer: #{e.message}"
         flash.now[:error] = "There was a problem processing your credit card. #{e.message}"
         false
       
        rescue Stripe::CardError => e
         logger.error "Stripe error while creating customer: #{e.message}"
         flash.now[:error] = "There was a problem processing your credit card. #{e.message}"
         false

         rescue Stripe::StripeError => e
         logger.error "Stripe error while creating customer: #{e.message}"
         flash.now[:error] = "There was a problem processing your credit card. #{e.message}"
         false

         
         
    end 


    def temp_password(token)
       @user.password=token
       @user.password_confirmation= token
    end 

end
