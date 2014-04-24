class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include UsersHelper
  include EventsHelper
  include SubscriptionsHelper

before_filter :prepare_for_mobile
before_filter :set_csp

def set_csp
  response.headers['Content-Security-Policy'] = "default-src 'self' 'unsafe-inline' 'unsafe-eval' *.ning.com *.facebook.com *.olark.com *.google-analytics.com *.facebook.net *.ning.com *.stripe.com *.vimeo.com *.amazonaws.com *.googleapis.com *.googleusercontent.com;script-src 'self' 'unsafe-inline' 'unsafe-eval' *.facebook.com *.olark.com *.google-analytics.com *.facebook.net *.ning.com *.stripe.com *.amazonaws.com *.vimeo.com *.googleapis.com"
  response.headers['X-Content-Security-Policy'] = "default-src 'self' 'unsafe-inline' 'unsafe-eval' *.ning.com *.facebook.com *.olark.com *.google-analytics.com *.facebook.net *.ning.com *.stripe.com *.vimeo.com *.amazonaws.com *.googleapis.com *.googleusercontent.com;script-src 'self' 'unsafe-inline' 'unsafe-eval' *.facebook.com *.olark.com *.google-analytics.com *.facebook.net *.ning.com *.stripe.com *.amazonaws.com *.vimeo.com *.googleapis.com"
  response.headers['X-Webkit-CSP'] = "default-src 'self' 'unsafe-inline' 'unsafe-eval' *.ning.com *.facebook.com *.olark.com *.google-analytics.com *.facebook.net *.ning.com *.stripe.com *.vimeo.com *.googleapis.com *.amazonaws.com *.googleusercontent.com;script-src 'self' 'unsafe-inline' 'unsafe-eval' *.facebook.com *.olark.com *.google-analytics.com *.facebook.net *.ning.com *.stripe.com *.vimeo.com *.amazonaws.com *.googleapis.com"
  response.headers['Access-Control-Allow-Origin'] = "*"
end

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
