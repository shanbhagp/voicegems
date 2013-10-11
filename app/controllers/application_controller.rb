class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include UsersHelper
  include EventsHelper
  include SubscriptionsHelper

before_filter :prepare_for_mobile

private

def mobile_device?
  if session[:mobile_param]
    session[:mobile_param] == "1"
  else
    request.user_agent =~ /Mobile|webOS/
  end
end
helper_method :mobile_device?

def prepare_for_mobile
  session[:mobile_param] = params[:mobile] if params[:mobile]
  #request.format = :mobile if mobile_device?
  # if use the above line, every action will look for an mobile.erb file if on a mobile device, and say missing template otherwise.
end

end
