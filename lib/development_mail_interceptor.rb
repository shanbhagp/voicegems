class DevelopmentMailInterceptor
  def self.delivering_email(message)
  	unless message.bcc == 'shanbhagp@aol.com'
    	message.subject = "#{message.to} #{message.subject}"
    	message.to = "shanbhagp@aol.com"
    end 
  end
end

