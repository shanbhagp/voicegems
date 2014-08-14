class UserMailer < ActionMailer::Base
  default from: "no-reply@voicegems.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #


def password_reset(user, url)
  @user = user
  @url = url 
  mail :to => user.email, :subject => "Password Reset"
end

def welcome(user)
  @user = user
  mail :to => user.email, :subject => "Welcome to VoiceGems"
end

def vg_welcome(user)
  @user = user
  mail :to => user.email, :subject => "Welcome to VoiceGems"
end

def password_change(user, to)
  @user = user
  mail :to => to, :subject => "Password update for your VoiceGems account"
end 

def sub_receipt(user, receipt)

  @user = user
  @r = receipt

  mail :to => user.email, :subject => "VoiceGems Subscription Receipt"

end 


def sub_receipt_edu(user, receipt)

  @user = user
  @r = receipt

  mail :to => user.email, :subject => "VoiceGems Subscription Receipt"

end 

def purchase_receipt(user, receipt, t1, t2, t3, t1l, t2l)

  @user = user
  @r = receipt
  @number = @r.events_number

    if @number.to_i <= t1l  
       @cost = @number.to_i*t1*100 # in cents
       @price = "$#{t1}" 
    end 
    if @number.to_i > t1l && @number.to_i <= t2l
       @cost = @number.to_i*t2*100 # in cents
       @price = "$#{t2}"
    end 
    if @number.to_i > t2l
       @cost = @number.to_i*t3*100 #in cents
       @price = "$#{t3}"
    end 

  mail :to => user.email, :subject => "VoiceGems Receipt"

end 

def trial_receipt(user, receipt, t1, t2, t3)

  @user = user
  @r = receipt
  @number = @r.events_number

    if @number.to_i < 16 
       @cost = @number.to_i*t1
       @price = "$#{t1}" 
    end 
    if @number.to_i > 15 && @number.to_i < 41 
       @cost = @number.to_i*t2
       @price = "$#{t2}"
    end 
    if @number.to_i > 40 
       @cost = @number.to_i*t3
       @price = "$#{t3}"
    end 

  mail :to => user.email, :subject => "VoiceGems Receipt"

end 

def grad_purchase_receipt(user, receipt, cost, price)
# cost in dollars
  @user = user
  @r = receipt
  @number = @r.events_number
  @cost = cost
  @price = "$#{price}"

  mail :to => user.email, :subject => "VoiceGems Receipt"

end 

def wed_purchase_receipt(user, receipt, cost, price)
# cost in dollars
  @user = user
  @r = receipt
  @number = @r.events_number
  @cost = cost
  @price = "$#{price}"

  mail :to => user.email, :subject => "VoiceGems Receipt"

end 



def testemail(email)
  @email = email
  mail :to => @email.recipient_email, :subject => @email.subject, :from => @email.from_email, :body => @email.body
end 


def dj_invitation(invitation)
  @invitation = Djinvite.find(invitation)
  
  if !@invitation.sender_name.blank?
     @subject = "A request from your client, #{@invitation.sender_name}, to mix music with meaning!"
  else
     @subject = "A request from your client, #{@invitation.sender_email}, to mix music with meaning!" 
  end

  mail :to => @invitation.recipient_email, :subject => @subject 

end 

end
