module SessionsHelper


	def sign_in(u)
    cookies.permanent[:remember_token] = u.remember_token
    self.current_user = u
    #use when setting (Rather than getting, or setting instance variables)
    #when we assign u to current_user here, we require a setter method, which is given below. 
    # that is, self.current_user = u automatically converts to current_user=(u), so we need to define
    # the setter method current_user=(x).  As defined below, this method takes the argument x and sets it to the 
    # @current_user instance variable, storing it for later use.  So when we pass in u to sign_in(u), we end up setting 
    # @current_user to u. (which will be user). 
    # self is necessary so that it doesn't create a local variable called current_user, but instead uses the definition below
   end

 def current_user=(x)
    @current_user = x
  end
  #this is to define the method of setting a current_user used in the def below (for current_user)
  # and the def above?
  

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end 
    # this is the getter method, which either takes the existing value of @current_user if there is one (which will
    # be the case if somoene has signed in and hasn't closed browser yet [I think this is why these definitions are in the
    # sessions_helper, rather than any database model; they pertain to what's going on in a person's browser]), otherwise 
    # sets current_user to the user associated with the cookie (if someone has signed in, closed the browser, but hasn't 
    # signed out yet) -- THIS IS PROBABLY NOT RIGHT - it just hits the find_by the first time current_user is used 
# for a request, and then any further times... 
# TRY AGAIN:  I think this is a getter method.  It sets @current_user to it's existing values is defined, otherwise
# it finds_by.  It sets @current_user in either case. 

  def signed_in?
    !current_user.nil?
  end
  #most of the time this will look to see if there's a remember token on the browser (and return the user with that remember 
    #token, as defined by current_user.  Sometimes (the second time current_user is called before a new request) 
    # it will return @current_user (and be true, since current_user not nil))


  def sign_out
  	self.current_user = nil
    cookies.delete(:remember_token)
  end
  # this deletes the remember_token on the browser (but leaves the remember_token in the user record) (I think),
  # and sets @current_user to nil (via the current_user= method)

  def current_user?(user)
    user == current_user
    # could use x instead of user (it's a variable)
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to root_path, notice: "Please sign in."
    end
  end



end
