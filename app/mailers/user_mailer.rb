class UserMailer < ActionMailer::Base
  default from: "passwords@namecoach.com"

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
	mail :to => user.email, :subject => "Welcome to NameCoach"
end

def password_change(user, to)
  @user = user
  mail :to => to, :subject => "Password update for your NameCoach account"
end 

end
