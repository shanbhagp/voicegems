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

def djs

     @event = Event.find(ENV['demopage'].to_i)
     @event_code = @event.event_code
     @url = demo_record_vg_url(:event_code => @event.event_code)
     if is_valid_percent_off_coupon(params[:promo_code])
         @coupon = Coupon.find_by_free_page_name(params[:promo_code])
         session[:coupon] = @coupon
     end
     
  render :layout => "static1"
end 

def weddings

#   @first_plan = Plan.find_by_my_plan_id(plan_set_one) # sets @first_plan the first plan object ACCORDING TO MY LEGEND (with my_plan_id)
#   @second_plan = Plan.find_by_my_plan_id(plan_set_two)
#   @third_plan = Plan.find_by_my_plan_id(plan_set_three)
  @event = Event.find(ENV['demopage'].to_i)
  @first_plan = Plan.find_by_my_plan_id(plan_set_one) # sets @first_plan the first plan object ACCORDING TO MY LEGEND (with my_plan_id)
  @second_plan = Plan.find_by_my_plan_id(plan_set_two)
  @third_plan = Plan.find_by_my_plan_id(plan_set_three)
  @practiceobject = Practiceobject.new  
  @practiceobject.event_id = @event.id #for the form_for(@practiceobject) which creatse a new practice object (and another form which just shows the labels - can find a better way for that)
  @registeredandrecordedpos = @event.practiceobjects.registered.recorded.visible
  @registeredandunrecordedpos = @event.practiceobjects.registered.unrecorded.visible
  @unregisteredpos = @event.practiceobjects.unregistered.visible
  @hiddenpos = @event.practiceobjects.hidden
  @hiddenandregisteredpos  = @hiddenpos.registered
  @hiddenandunregisteredpos = @hiddenpos.unregistered  

  @url = demo_record_wedding_url(:event_code => @event.event_code)

end 

def receptions
  @event = Event.find(ENV['demopage'].to_i)
  @first_plan = Plan.find_by_my_plan_id(plan_set_one) # sets @first_plan the first plan object ACCORDING TO MY LEGEND (with my_plan_id)
  @second_plan = Plan.find_by_my_plan_id(plan_set_two)
  @third_plan = Plan.find_by_my_plan_id(plan_set_three)
  @practiceobject = Practiceobject.new  
  @practiceobject.event_id = @event.id #for the form_for(@practiceobject) which creatse a new practice object (and another form which just shows the labels - can find a better way for that)
  @registeredandrecordedpos = @event.practiceobjects.registered.recorded.visible
  @registeredandunrecordedpos = @event.practiceobjects.registered.unrecorded.visible
  @unregisteredpos = @event.practiceobjects.unregistered.visible
  @hiddenpos = @event.practiceobjects.hidden
  @hiddenandregisteredpos  = @hiddenpos.registered
  @hiddenandunregisteredpos = @hiddenpos.unregistered  

  @url = demo_record_wedding_url(:event_code => @event.event_code)

end 

def commencements
  @event = Event.find(ENV['demopage'].to_i)
  @commencement_plan = Plan.find_by_my_plan_id(plan_set_commencement) # sets @first_plan the first plan object ACCORDING TO MY LEGEND (with my_plan_id)
  @students_plan = Plan.find_by_my_plan_id(plan_set_students)
  @all_inclusive_plan = Plan.find_by_my_plan_id(plan_set_all_inclusive)
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

def students
  @event = Event.find(ENV['demopage'].to_i)
  @commencement_plan = Plan.find_by_my_plan_id(plan_set_commencement) # sets @first_plan the first plan object ACCORDING TO MY LEGEND (with my_plan_id)
  @students_plan = Plan.find_by_my_plan_id(plan_set_students)
  @all_inclusive_plan = Plan.find_by_my_plan_id(plan_set_all_inclusive)
  @practiceobject = Practiceobject.new  
  @practiceobject.event_id = @event.id #for the form_for(@practiceobject) which creatse a new practice object (and another form which just shows the labels - can find a better way for that)
  @registeredandrecordedpos = @event.practiceobjects.registered.recorded.visible
  @registeredandunrecordedpos = @event.practiceobjects.registered.unrecorded.visible
  @unregisteredpos = @event.practiceobjects.unregistered.visible
  @hiddenpos = @event.practiceobjects.hidden
  @hiddenandregisteredpos  = @hiddenpos.registered
  @hiddenandunregisteredpos = @hiddenpos.unregistered  

  @url = demo_record_directory_url(:event_code => @event.event_code)

end 

# FOR TESTING LAYOUT
def students_extra 
  @event = Event.find(ENV['demopage'].to_i)
  @commencement_plan = Plan.find_by_my_plan_id(plan_set_commencement) # sets @first_plan the first plan object ACCORDING TO MY LEGEND (with my_plan_id)
  @students_plan = Plan.find_by_my_plan_id(plan_set_students)
  @all_inclusive_plan = Plan.find_by_my_plan_id(plan_set_all_inclusive)
  @practiceobject = Practiceobject.new  
  @practiceobject.event_id = @event.id #for the form_for(@practiceobject) which creatse a new practice object (and another form which just shows the labels - can find a better way for that)
  @registeredandrecordedpos = @event.practiceobjects.registered.recorded.visible
  @registeredandunrecordedpos = @event.practiceobjects.registered.unrecorded.visible
  @unregisteredpos = @event.practiceobjects.unregistered.visible
  @hiddenpos = @event.practiceobjects.hidden
  @hiddenandregisteredpos  = @hiddenpos.registered
  @hiddenandunregisteredpos = @hiddenpos.unregistered  

  @url = demo_record_directory_url(:event_code => @event.event_code)

end 

def students_naesp
  @event = Event.find(ENV['demopage'].to_i)
  @commencement_plan = Plan.find_by_my_plan_id(plan_set_commencement) # sets @first_plan the first plan object ACCORDING TO MY LEGEND (with my_plan_id)
  @students_plan = Plan.find_by_my_plan_id(plan_set_students)
  @all_inclusive_plan = Plan.find_by_my_plan_id(plan_set_all_inclusive)
  @practiceobject = Practiceobject.new  
  @practiceobject.event_id = @event.id #for the form_for(@practiceobject) which creatse a new practice object (and another form which just shows the labels - can find a better way for that)
  @registeredandrecordedpos = @event.practiceobjects.registered.recorded.visible
  @registeredandunrecordedpos = @event.practiceobjects.registered.unrecorded.visible
  @unregisteredpos = @event.practiceobjects.unregistered.visible
  @hiddenpos = @event.practiceobjects.hidden
  @hiddenandregisteredpos  = @hiddenpos.registered
  @hiddenandunregisteredpos = @hiddenpos.unregistered  

  @url = demo_record_directory_url(:event_code => @event.event_code)

end 

def students_naspa
  @event = Event.find(ENV['demopage'].to_i)
  @commencement_plan = Plan.find_by_my_plan_id(plan_set_commencement) # sets @first_plan the first plan object ACCORDING TO MY LEGEND (with my_plan_id)
  @students_plan = Plan.find_by_my_plan_id(plan_set_students)
  @all_inclusive_plan = Plan.find_by_my_plan_id(plan_set_all_inclusive)
  @practiceobject = Practiceobject.new  
  @practiceobject.event_id = @event.id #for the form_for(@practiceobject) which creatse a new practice object (and another form which just shows the labels - can find a better way for that)
  @registeredandrecordedpos = @event.practiceobjects.registered.recorded.visible
  @registeredandunrecordedpos = @event.practiceobjects.registered.unrecorded.visible
  @unregisteredpos = @event.practiceobjects.unregistered.visible
  @hiddenpos = @event.practiceobjects.hidden
  @hiddenandregisteredpos  = @hiddenpos.registered
  @hiddenandunregisteredpos = @hiddenpos.unregistered  

  @url = demo_record_directory_url(:event_code => @event.event_code)

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

def macfaq
end

def flashtest
  render :layout => nil
end 

def support_test
  #render :layout => nil
end 

def macbeathtestimonial
  #render :layout => nil
end 

def search_test
end

def flashdetect
 # render :layout => nil
end 

def precord
 # if params[:ZenId]
  #@ZenId = params[:ZenId]
 # else
 # @ZenId = 4 
 # end  
  #@practiceobject = current_user.practiceobjects.first
  @practiceobject = Practiceobject.find(params[:po])
   @event = @practiceobject.event
  render :layout => nil
 


end

def precord2
  # @practiceobject = current_user.practiceobjects.first
  @practiceobject = Practiceobject.find(params[:po]) 
  @event = @practiceobject.event
  render :layout => nil
end 


def irecord
render :layout => nil
end 

def isave

      directory = "app/assets/images"
      # create the file path
      path = File.join(directory, current_user.id.to_s)
      path+='.mov'
     # write the file to local images directory
      File.open(path, "wb") { |f| f.write(request.body.read) }

      #upload to S3
       bucket_name = ENV['BUCKET_NAME']
       source_filename = path 

        AWS.config(
          :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
          :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
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
                      :api_key => ENV['ZEN_API_KEY'],    
                      :input => "s3://#{ENV['BUCKET_NAME']}/#{current_user.id.to_s}.mov",
                      :outputs => [
                        {
                          :url => "s3://#{ENV['BUCKET_NAME']}/#{current_user.id.to_s}.mp3",
                          :audio_codec => "mp3",
                          :skip_video => true,
                          :public => 1,

                          }]

                          })

#{
 # "input": "s3://zencoder-customer-ingest/uploads/2013-07-24/71268/58113/4c797080-f434-11e2-8421-47a170fadea2.mov",
 # "output": [
 #   {
 #     "skip_video": true,
 #     "audio_codec": "mp3"
 ## ]
#}

        #update the recording path for the current user and the (first?) practice object; this is coped from the upload action, and 
        # cleans up the code by using current_user
        #this should really only happen for the users first(only) practiceobject, as after that they are forced to edit a PO through the PO update action.
        #important to have it here so that as soon as the user first records, his PO's recording path gets a value
        current_user.update_attributes(recording: current_user.id)
          if current_user.practiceobjects.any? 
             current_user.practiceobjects.each do |x|
               if x.recording.blank?
               x.update_attributes(recording: current_user.recording)
               end 
             end    
          end 

      redirect_to current_user

  end


def googlev
  render :layout => nil
end

def mockup


       @event = Event.find(ENV['demopage'].to_i)
     @event_code = @event.event_code
     @url = demo_record_vg_url(:event_code => @event.event_code)
     
end 


def audior_index
   render :layout => nil
end 

# NOW USING VG_AUDIOR_UPLOAD INSTEAD
def audior_upload

    #write to local directory
          begin
            @f = File.new("#{Rails.root}/public/audio_clips/#{params[:userId]}.mp3", "wb")
            @f.write(request.raw_post)
            @f.close
            render :text => "save=ok&fileurl=/audio_clips/#{params[:userId]}"
          rescue
            render :text => "save=fail"
          end
       
    #upload to S3  - note that needed to add .mp3, and that content-type being saved as image for some reason
       bucket_name = ENV['VG_BUCKET_NAME']
       source_filename = "#{Rails.root}/public/audio_clips/#{params[:userId]}.mp3" 

        AWS.config(
          :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
          :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
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

        logger.warn "AUDIOR_UPLOAD"

       logger.warn params[:userId]
       
end

#not using anymore (just using an asset path in the audior index file )
def audior_settings
respond_to do |format|

    format.xml
  end
end


def auphonic
end

def couples

     @event = Event.find(ENV['demopage'].to_i)
     @event_code = @event.event_code
     @url = demo_record_vg_url(:event_code => @event.event_code)


     render :layout => "static1"
end 

def home_page
end 

def invite_dj

  @invite = Djinvite.new
  @invite.sender_email = params[:invite][:sender_email]
  @invite.sender_name = params[:invite][:sender_name]
  @invite.recipient_email = params[:invite][:recipient_email]
  @invite.recipient_name = params[:invite][:recipient_name]
  @invite.sent_at = Time.now

  #check if email is already in DB - if so, send an email that this person is interested in using VoiceGems 
  # if not, send an invite
          if @invite.save  
              #AdminInviteMailer.admin_invitation(@ai, new_user_url(:token => @practiceobject.token), @practiceobject).deliver 
              UserMailer.dj_invitation(@invite.id).deliver 
              redirect_to couples_path(anchor: 'invite'), notice: "An email invitation has been sent to #{@invite.recipient_email} - we hope you enjoy our service at your event!"
          else
              redirect_to couples_path(anchor: 'invite'), notice: 'Something went wrong - please make sure to enter valid email addresses'
            # see if we can use render here (how to do that?) and thereby get the validation errors
          end


end

end
