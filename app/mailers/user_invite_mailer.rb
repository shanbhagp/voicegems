class UserInviteMailer < ActionMailer::Base
  default from: "shanbhagp@aol.com"
  #note that still sends from prshanbhag@gmail.com
  default headers['X-No-Spam'] = 'True'

  def user_invitation (userinvite, url, po, bcc)
    @po = po
    @url = url
    @userinvite = userinvite 
    #subject  "Name registration for event: #{@po.event.title}" 
    #body  :userinvite => userinvite, :url => url, :po => po
    mail to: po.email, subject: "Name registration for event: #{@po.event.title}", bcc: bcc
    #mail to: "to@example.org"
    userinvite.update_attribute(:sent_at, Time.now)
  end

  def invite_reminder(userinvite, url, po, bcc)
    @po = po
    @url = url
    @userinvite = userinvite 
    #subject  "Name registration for event: #{@po.event.title}" 
    #body  :userinvite => userinvite, :url => url, :po => po
    mail to: po.email, subject: "Reminder: name registration for event: #{@po.event.title}", bcc: bcc
    #mail to: "to@example.org"
    userinvite.update_attributes(:sent_at => Time.now, :invite_type => "registration reminder")
  end

  def recording_reminder(userinvite, url, po)
    @po = po
    @url = url
    @userinvite = userinvite 
    #subject  "Name registration for event: #{@po.event.title}" 
    #body  :userinvite => userinvite, :url => url, :po => po
    mail to: po.user.email, subject: "Please record your name for event: #{@po.event.title}"
    #mail to: "to@example.org"
    userinvite.update_attributes(:sent_at => Time.now, :invite_type => "request to record")
  end

  def rerecording_reminder(userinvite, url, po)
    @po = po
    @url = url
    @userinvite = userinvite 
    #subject  "Name registration for event: #{@po.event.title}" 
    #body  :userinvite => userinvite, :url => url, :po => po
    mail to: po.user.email, subject: "Request to re-record your name for event: #{@po.event.title}"
    #mail to: "to@example.org"
    userinvite.update_attributes(:sent_at => Time.now, :invite_type => "request to re-record")
  end


  def existing_user_invitation (userinvite, url, po)
    @po = po
    @url = url
    @userinvite = userinvite 
    @u = User.find_by_email(@po.email)
    #subject  "Name registration for event: #{@po.event.title}" 
    #body  :userinvite => userinvite, :url => url, :po => po
    mail to: po.user.email, subject: "Name registration for event: #{@po.event.title}"
    #mail to: "to@example.org"
    userinvite.update_attribute(:sent_at, Time.now)
  end


end
