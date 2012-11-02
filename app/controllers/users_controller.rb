class UsersController < ApplicationController
  # GET /users
  # GET /users.json
before_filter :signed_in_user, only: [:show, :edit, :update, :account, :stripenewcustomer, :stripetest, :setpassword, :console, :index]
before_filter :correct_user, only: [:show, :edit, :update, :account, :setpassword]
before_filter :not_customer, only: [:stripenewcustomer, :stripetest]
before_filter :owner, only: [:console, :index]


  def home
    # check if signed_in and then display (you are currently signed in, view your profile)
    # automatically renders page 'users/home'
     @user = User.new
  end

  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  def skip
    flash[:info] = "Welcome to your NameCoach profile page. You may need to wait a minute and refresh the page to hear your name recording below."
    redirect_to current_user
  end 

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    #@user.password = BCrypt::Password.new(@user.password_digest)
    #@user.password_confirmation = @user.password
    if @user.phonetic.blank?
      if @user.first_name && @user.last_name
      @user.phonetic = @user.first_name + ' ' + @user.last_name 
      end 
    end  
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
     # if signed_in?
     #  redirect_to root_path  
     # else
      @user = User.new(:invite_token => params[:token])
          if  Practiceobject.find_by_token(@user.invite_token)
                 @po = Practiceobject.find_by_token(@user.invite_token)
                 @user.email = @po.email
                 #this is some polish to automatically set the email field in the form
                 #flash[:notice] = "You have been invited, please sign up and record your name!"
                 #put this back in later when you've figured out the flash/notice thing, included notices inthe application layout
                if @po.first_name
                  @user.first_name = @po.first_name
                end 
                if @po.last_name
                  @user.last_name = @po.last_name
                end 
      #maybe check to see first if there is a token passed in: if params[:token].any? or something; or rather, if
      # the @user already has a :token attribute b/c rendered from a failed create attempt below
      #actually, it seems that users are still being appropriately assoaciated with their practice objects even when they mess up the invited 
      # signup  - I think somehow the token is being passed in here from the failed sign-up as params[:token]? (associated with incoming @user object, which
        #hasn't been reset yet (available to be assigned once more to @user)) no, that seems unlikely since the associated user attribute is
      #invite_token, not token.
      #ANSWER:  we are just re-rendering new, not hitting the new action - none of the new action logic is being executed - @user still has all it's associated
      #fields, including the :invite_token.  
          else 
            redirect_to root_path, notice: 'Invitation invalid or used. If you already signed up, please sign in. If you were following an invite link, please retry the link or contact your event admin.'
             #in case a bad token passed in; but doesn't work for a blank/nil token (when someone just hits users/new without an invite); probably 
                # b/c there are some PO's with nil/blank tokens; also in case user already signed up with that token
          end

   #  end

   end

   def new_step2
      @user = current_user
      @po = Practiceobject.find_by_token(params[:token])
   end 


  def setpassword
    flash.now[:info] = "Thank you! You have been given a temporary password. You will need to set a password to access this account in the future."
    @user = User.find(params[:id])
  end 

  #UNUSED (I think)  
  # GET /users/1/edit
  def edit
   @user = User.find(params[:id])
   # @user.password = BCrypt::Password.new(@user.password_digest)
   #@user.password_confirmation = @user.password

  end

  # POST /users
  # POST /users.json
  def create  #just for invited with token user signup
    @user = User.new
    @user.email = params[:user][:email]
    @pw = SecureRandom.urlsafe_base64
    @user.invite_token = params[:user][:invite_token]
    @user.password=@pw
    @user.password_confirmation=@pw
    @user.first_name = params[:user][:first_name]
    @user.last_name = params[:user][:last_name]
    @user.phonetic = params[:user][:phonetic]
    @user.notes = params[:user][:notes]


    if @user.save  then 
            UserMailer.welcome(@user).deliver
            sign_in @user
            if  Practiceobject.find_by_token(@user.invite_token)  #probably not necessary, just avoiding nomethod errors    
                @po = Practiceobject.find_by_token(@user.invite_token) #note that don't need to check if there's a PO for this event w/ this users's email, because this is only a problem if an invited attendee signs up with an email address for another attendee (and this would show up under the email field)
                @po.user_id = @user.id                                #plus, we want this user to be stuck with the PO that was sent to his inbox anyway, so if he signs in with the em address for another invited attendee, that will only affect his PO and show that he was invited at a different em address but using this other one.
                                                                      # plus, we can cover this sort of chicanery by sending a confirmation email whenever a new user signs up. 
                @po.notes = @user.notes
                @po.phonetic = @user.phonetic
                @po.token = "used"
                if @po.save #just to be sure, wrapping this in an if-else-end.  Would fail only if somehow user already had a PO for this event (which couldn't happen because signing up with same email is already not allowed)
                  flash[:info] = "Now just record your name, and you're done!"

                  redirect_to new_step2_path(:token => @po.token)
                else
                  redirect_to new_step2_path(:token => @po.token)
                end 
            else #couldn't find practice object by token
                  redirect_to new_step2_path(:token => @po.token), notice: 'There was an error.  Please sign out and try again.'
            end 
    else  
          if  User.find_by_email(@user.email)#if the user already exists, tell them to try logging in to the right; won't save becaues @user represents a User.new record here
              flash.now[:error] = "You have previously registered on our site. Please follow the link below ('Already Registered on our Site?') and sign in.  Click 'Reset Password' above if you haven't set a password yet." 
          end 
          if  Practiceobject.find_by_token(@user.invite_token)
                 @po = Practiceobject.find_by_token(@user.invite_token)
                 if @user.email.blank?
                    @user.email = @po.email
                 end 
          end # to re-render personalized invite info
          
            render action: 'new'  #this is causing a problem: render 'new' wont' work bc the view requires the controller to set @po, but when coming from the 
                                      # home page, we bypass setting @po.  I think this is fixed now.
                              # failed save attempt from 'new' form without an invite creates a problem b/c @po not set.  fixed by redirect to root path in 'new' action 
    end
    #respond_to do |format|
     # if @user.save
      #  sign_in @user
      #  format.html { redirect_to edit_user_path(@user), notice: 'Welcome to Namewaves.' }
        # format.json { render json: @user, status: :created, location: @user }
     # else
      #  format.html { render action: "new" }
        #format.json { render json: @user.errors, status: :unprocessable_entity }
    #  end
    #end
end


#think this is no longer being used.
  def homepageusercreate
    @user = User.new
    @user.email = params[:user][:email]
    @user.password=params[:user][:password]
    @user.password_confirmation=params[:user][:password_confirmation] 

    if @user.save  
        sign_in @user     
        redirect_to @user, notice: 'Welcome to NameCoach! From here, you can edit your NameGuide, or sign up for a free trial to use our NameCoach service.'
    else
        render action: 'home'  #this is causing a problem: render 'new' wont' work bc the view requires the controller to set @po, but when coming from the 
                                      # home page, we bypass setting @po.
    end
  end 

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])
  
  
      if @user.update_attributes(params[:user])  

            if @user.practiceobjects.count == 1  #this should fix the problem from below- we're only dealing with situations in which the user has 1 PO
              @user.practiceobjects.each do |p|  # this makes any changes to user notes/name as announced default changes for any blank parallel fields in the users PO's.  
                                                # mainly to update the practiceobject when the user first fills out that info
                  
                  # this SHOULD only update the PO when the user has only one PO, because won't have access to the form that hits this action if he has more than one PO
                  #NEED TO MAKE SURE OF THIS - MAKE SURE THIS ACTION NOT HIT FROM ANYWHERE ELSE, not hit any other time the PO is updated - IS IT HIT WHEN ADMIN NOTES UPDATED THROUGH BEST IN PLACE?
                    # after looking at the terminal output, it doesn't look like best_in_place hits this update action, so it's cool
                    #THIS WON"T WORK - ANY update to the user, e.g. when updating password, will change all PO values back to the default - see fix above
                    p.update_attributes(:notes => @user.notes)
                  
                  
                    p.update_attributes(:phonetic => @user.phonetic)
                end 
            end 

          if params[:user][:password]
             UserMailer.password_change(@user).deliver 
             redirect_to @user, notice: 'Password update was successful.' 
          else
            if params[:user][:email]
              redirect_to @user, notice: 'User update was successful.'
            else 
             redirect_to @user, notice: 'Nameguide update was successful.  If you recorded your name, please wait a minute and refresh the page to see the changes take effect.' 
            end 
          end       
          
     
      else
          if params[:user][:password]
              render action: "setpassword" 
          else
                  if params[:user][:email]
                    render action: "edit"
                  else
                  flash[:error] = "Something went wrong, please try again."
                   redirect_to current_user
                  end 
          end
        #format.html { render action: "edit" } redirect_to(session[:return_to] || edit_user_path)
       # format.html { redirect_to (session[:return_to] || edit_user_path(@user))} 
        #format.json { render json: @user.errors, status: :unprocessable_entity }
      end
  
  end

  #for changing password once you've signed in
  def changepassword
    @user = current_user
    if @user.update_attributes(params[:user]) then 
         UserMailer.password_change(@user).deliver 
         redirect_to @user, notice: 'Password update was successful.' 
    else
        render action: "account"
    end 
  end 

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

def account
   @user = User.find(params[:id])
   #store_location
end
# this is not giving the proper error messages because redirecting rather than rendering in the update action
# can either try to render instead of redirect, or 
#this is working now!
# don't remember why i have store_location in here - I think i take care of the proper redirects/renders in the update action, so no need

#def post_account
# @user = User.find(params[:id])

#    respond_to do |format|
 #    if @user.update_attributes(params[:user])
 #       format.html { redirect_to @user, notice: 'User was successfully updated.' }
 #       format.json { head :no_content }
 #     else
 #       format.html { render action: "account" }
 #     format.json { render json: @user.errors, status: :unprocessable_entity }
 #    end
 #   end
#end

def invitedsignup
  redirect_to root_path
end
#don't think this is being  used


def console
end

# NOT BEING USED (I think)
def saverecording
 @user = current_user
 @user.update_attributes(recording: @user.id)
if Practiceobject.find_by_user_id(@user.id)
   @po = Practiceobject.find_by_user_id(@user.id)
   #need to make sure this updates the CURRENT practice object (not just the first one found)!  In general, allow user to update the PO recording rather than 
   #the user recording when he has multiple po's 
   @po.update_attributes(recording: @user.recording)
end 
 redirect_to @user, notice: 'Recording saved'
end


def test
  @user = User.find(params[:id])
  render :layout => nil
  # necessary b/c having the rendered header was causing problems on the test page
end 

# NOT BEING USED (I think)
def upload
       @user = current_user
 @user.update_attributes(recording: @user.id)
if Practiceobject.find_by_user_id(@user.id)
   @po = Practiceobject.find_by_user_id(@user.id)
   #need to make sure this updates the CURRENT practice object (not just the first one found)!  In general, allow user to update the PO recording rather than 
   #the user recording when he has multiple po's 
   @po.update_attributes(recording: @user.recording)
end 
 redirect_to test_user_path(current_user), notice: 'Recording uploaded'

end


def saveupload

      directory = "app/assets/images"
      # create the file path
      path = File.join(directory, current_user.id.to_s)
      path+='.wav'
     # write the file to local images directory
      File.open(path, "wb") { |f| f.write(request.body.read) }

      #upload to S3
       bucket_name = 'namewaves'
       source_filename = path 

        AWS.config(
          :access_key_id => 'AKIAJCTJ7WYDRGWUPFLA',
          :secret_access_key => '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'
        )

        # Create the basic S3 object
        s3 = AWS::S3.new

        # Load up the 'bucket' we want to store things in
        bucket = s3.buckets[bucket_name]

        # If the bucket doesn't exist, create it
        unless bucket.exists?
          puts "Need to make bucket #{bucket_name}.."
          s3.buckets.create(bucket_name)
        end

        # Grab a reference to an object in the bucket with the name we require
        object = bucket.objects[File.basename(source_filename)]

        # Write a local file to the aforementioned object on S3
        object.write(:file => source_filename)
       
        #transcode the file as a genuine mp3 via Zencoder
        Zencoder::Job.create({
                      :api_key => '8ed73c17bb8e345b0c42a69fe02bab96',    
                      :test => true, 
                      :input => "s3://namewaves/#{current_user.id.to_s}.wav",
                      :outputs => [
                        {
                          :url => "s3://namewaves/#{current_user.id.to_s}.mp3",
                          :audio_codec => "mp3",
                          :public => 1,

                          }]

                          })



        #update the recording path for the current user and the (first?) practice object; this is coped from the upload action, and 
        # cleans up the code by using current_user
        #this should really only happen for the users first(only) practiceobject, as after that they are forced to edit a PO through the PO update action.
        #important to have it here so that as soon as the user first records, his PO's recording path gets a value
        current_user.update_attributes(recording: current_user.id)
          if current_user.practiceobjects.any? 
             current_user.practiceobjects.each do |x|
             x.update_attributes(recording: current_user.recording)
             end    
          end 

  end



def eventcodesignup
    @user = User.new
end 

# for event code url signup
#def signup
#  @user = User.new 
#end 

def eventcodesignup_step2
   @user = current_user
end 

def eventcodesignupcreate  #for new users signing up with an event code
    @user = User.new
    @user.email = params[:user][:email]
    @pw = SecureRandom.urlsafe_base64
    @user.password=@pw
    @user.password_confirmation=@pw
    @user.first_name = params[:user][:first_name]
    @user.last_name = params[:user][:last_name]
    @user.phonetic = params[:user][:phonetic]
    @user.notes = params[:user][:notes]
    @user.event_code = params[:user][:event_code]
          #moved this up here so that what user entered is left in tact when re-renders form, and can take out @user = User.new below 

if !params[:user][:event_code].blank? #see if any code parameter is passed incoming from the form - don't want to run this code if not, i.e., if user is signing up                from an inviation token
    if Event.find_by_event_code(params[:user][:event_code].upcase.delete(' ')) # see if the code entered is even a code for any event - params[:code] is coming in from the form
                          #but how to get code in from the form?    
      @event  = Event.find_by_event_code(params[:user][:event_code].upcase.delete(' '))
      #run code to sign up user for this event, first to try to save the user (validate his info)
      
            if @user.save
                UserMailer.welcome(@user).deliver
                sign_in @user
                # try to give user a PO for this event
                  # first check to see if an existing PO with this email for this event, and leave the other events/PO's alone; if floating  # PO's with this email for other events, will be caught by the sign-up level checks - user can just sign in then to anchor 
                  # themselves to that PO/event
                  if !@event.practiceobjects.nil? && @event.practiceobjects.find_by_email(@user.email)  #there is an already a PO with user's em for this event, floating
                      @event.practiceobjects.find_by_email(@user.email).update_attributes(:user_id => @user.id, :phonetic => @user.phonetic, :notes => @user.notes) #this should validate b/c # user is new 
                      flash[:info] = "Now just record your name for this event (#{@event.title}), and you're done!"
                      redirect_to eventcodesignup_step2_path
                  else #no floating PO's associated with this email for this event (from an 'invite attendee' invitation), so give a new PO
                        @po = Practiceobject.new(:user_id => @user.id, :event_id => @event.id, :email => @user.email, :first_name => @user.first_name, :last_name => @user.last_name, :phonetic => @user.phonetic, :notes => @user.notes) #needed to add email to PO to make sure PO saves, b/c of PO validations}
                        if @po.save  #should be fine - since this is a new user, there can't be a PO for this event with his ID - true, but            #still problem if ADMIN ALSO INVITED AT THAT EMAIL ADDRESS, THEREBY CREATING A PO, AND USER HASN'T            #REGISTERED YET
                           flash[:info] = "Now just record your name for this event (#{@event.title}), and you're done!"
                           redirect_to eventcodesignup_step2_path
                        else #already a PO for this user_id and event, but this shouldn't happen since it's a new user
                          redirect_to @user, notice: "Thanks for registering. However, something may have gone wrong - please contact your event admin for #{@event.title} to see if they can view your NameGuide/recording. If they can't, please ask them to send you an email invitation to a different email."
                        end 
                  end 
                    
            else # user already exists, or otherwise didn't validate as user
                  #redirect back to this sign-up form - should render errors; if it's because ther user already exists, this is covered by the 
                  # sign-in form on form, but maybe good to check first and tell user to sign-in.  Notice: "If you have already registered, please sign in under 'Already Registered.'""
                    if  User.find_by_email(@user.email)#if the user already exists, tell them to try logging in to the right
                            flash[:error] = "You have previously registered on our site. Please sign in under 'Already Registered?' (below) to register for another event."
                             redirect_to eventcodesignup_path
                    else
                      render action: 'eventcodesignup'
                    end     
                    
            end   
    else #code entered doesn't exist for any event
      #@user = User.new #for the re-rendering of the eventcodesignup view
      #render this action again, with the flash message
      flash.now[:error] = 'The event code is not a valid code for any event.'
      render action: 'eventcodesignup'
    end 
else
  #@user = User.new #for the re-redering of the eventcodesignup view
  #run existing users#create code - maybe make this a helper method
  # or make this whole code a separate controller action, and just redirect to the form saying no code was entered
  flash.now[:error] = 'Please enter an event code.  You should have received this from the person inviting you to record your name for the event.'
  render action: 'eventcodesignup'
  
  
end

end


def admincodesignup
  @user = User.new 
end


def admincodesignupcreate #for new users signing up to admin with a code

          @user = User.new
          @user.email = params[:user][:email]
          @user.password=params[:user][:password]
          @user.password_confirmation=params[:user][:password_confirmation]
          @user.first_name = params[:user][:first_name]
          @user.last_name = params[:user][:last_name]
          @user.access_code = params[:user][:access_code]
          #moved this up here so that what user entered is left in tact when re-renders form, and can take out @user = User.new below 

if !params[:user][:access_code].blank? #see if any code parameter is passed incoming from the form - don't want to run this code if not, i.e., if user is signing up                from an inviation token
    if Event.find_by_access_code(params[:user][:access_code].upcase.delete(' ')) # see if the code entered is even an access(admin) code for any event - params[:code] is coming in from the form
                          #but how to get code in from the form?    
      @event  = Event.find_by_access_code(params[:user][:access_code].upcase.delete(' '))
      #run code to sign up user for this event, first to try to save the user (validate his info)
      @user.admin = true
            if @user.save
                sign_in @user
                #create adminkey for this event/user_id - should work b/c the user is brand new, so don't worry about wrapping save in an if statement
                @adminkey = Adminkey.new(event_id: @event.id, user_id: @user.id)
                @adminkey.save 
                # try to give user a PO for this event
                  # first check to see if an existing PO with this email for this event, and leave the other events/PO's alone; if floating  # PO's with this email for other events, will be caught by the sign-up level checks - user can just sign in then to anchor 
                  # themselves to that PO/event
                  if !@event.practiceobjects.nil? && @event.practiceobjects.find_by_email(@user.email)  #there is an already a PO with user's em for this event, floating
                      @event.practiceobjects.find_by_email(@user.email).update_attributes(:user_id => @user.id) #this should validate b/c # user is new 
                      redirect_to @user, notice: "Welcome to NameCoach, and thanks for registering to admin this event, #{@event.title}. Click on your event to invite people to record their names and practice recorded names. Also check out your own NameGuide to create or update it."
                  else #no floating PO's associated with this email for this event (from an 'invite attendee' invitation), so give a new PO
                        @po = Practiceobject.new(:user_id => @user.id, :event_id => @event.id, :email => @user.email, :first_name => @user.first_name, :last_name => @user.last_name) #needed to add email to PO to make sure PO saves, b/c of PO validations}
                        if @po.save  #should be fine - since this is a new user, there can't be a PO for this event with his ID - true, but            #still problem if ADMIN ALSO INVITED AT THAT EMAIL ADDRESS, THEREBY CREATING A PO, AND USER HASN'T            #REGISTERED YET
                          redirect_to @user, notice: "Welcome to NameCoach, and thanks for registering to admin this event, #{@event.title}.  Click on your event to invite people to record their names and practice recorded names. Also check out your own NameGuide to create or update it."
                        else #already a PO for this user_id and event, but this shouldn't happen since it's a new user
                          redirect_to @user, notice: "Thanks for registering as an admin for this event. However, something may have gone wrong - please contact your event admin for #{@event.title}."
                        end 
                  end 
                    
            else # user already exists, or otherwise didn't validate as user
                  #redirect back to this sign-up form - should render errors; if it's because ther user already exists, this is covered by the 
                  # sign-in form on form, but maybe good to check first and tell user to sign-in.  Notice: "If you have already registered, please sign in under 'Already Registered.'""
                    if  User.find_by_email(@user.email)#if the user already exists, tell them to try logging in to the right
                            flash[:error] = "You have previously registered on our site. Please sign in under 'Already Registered?' to register as an admin for another event."
                             redirect_to admincodesignup_path
                    else
                      render action: 'admincodesignup'
                    end     
                    
            end   
    else #code entered doesn't exist for any event
      #@user = User.new #for the re-rendering of the eventcodesignup view
      #render this action again, with the flash message
      flash.now[:error] = 'The admin code is not a valid code for any event.'
      render action: 'admincodesignup'
    end 
else
  #@user = User.new #for the re-redering of the eventcodesignup view
  #run existing users#create code - maybe make this a helper method
  # or make this whole code a separate controller action, and just redirect to the form saying no code was entered
  flash.now[:error] = 'Please enter an admin code.'
  render action: 'admincodesignup'
  
  
end



end #admincodesignupcreate


def stripetest
 
end 

def stripereceiver
  # get the credit card details submitted by the form
    token = params[:stripeToken]
    plan = params[:plan]

    if current_user.customer == true #user is already a customer  
                                      # this should not happen often b/c a customer won't have access to the sign-up link (but this will change when add single-use)      
      redirect_to current_user, notice: "You are already subscribed to our service. Your card was not charged."  

    else #user not already a customer 

        if create_customer(token, plan)
              #record stripe's (?) customer_id for this user
              # this helper is in users helper
          
          redirect_to current_user
        else
          render 'stripenewcustomer'
        end 

    end    
    

end 


def newcustomer
  @user = User.new 
end 

def newcustomercreate
  
    @user = User.new
    @user.email = params[:user][:email]
    @user.password=params[:user][:password]
    @user.password_confirmation=params[:user][:password_confirmation]
    @user.first_name = params[:user][:first_name]
    @user.last_name = params[:user][:last_name]

    if @user.save

      sign_in @user
      # since user is new, won't have any PO with user_id; might have floating PO's with this email for some event, but those would be caught later when customer signs in for those events
      # when creates an event, can invite himself (at that email) to create a PO for that event for himself
      flash[:success] = "Thank you for registering.  Please fill in your payment details to finish subscribing."
      if @user.email == 'shanbhagp@aol.com'
          @user.customer = true
          @user.save
      end 
      if @user.email == 'startx@example.com'
          @user.customer = true
          @user.save
      end 
      redirect_to stripenewcustomer_path 
    else

          if  User.find_by_email(@user.email)#if the user already exists, tell them to try logging in to the right
                        flash[:error] = "You are already registered on our site. Please sign in, and go to 'Purchase Subscription' under your Accounts tab."
                         redirect_to root_path
          else
              render action: 'newcustomer'
          end    

    end 

end 


def stripenewcustomer 
end 

#def hide
#  redirect_to root_path
#end 
#just for testing (deleting PO's) - not real code

end



